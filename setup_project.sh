#!/usr/bin/env bash

export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export GREEN='\033[1;32m'
export NC='\033[0m' # No Color

# shellcheck disable=SC1091
source ./variables.sh

az group create -n "${RG_NAME}" -l "${LOCATION}"

# Create postgres server
az postgres server create \
    -n "${POSTGRES_SERVER_NAME}" \
    -g"${RG_NAME}" \
    -l "${LOCATION}" \
    -u "${POSTGRES_SERVER_ADMIN}" \
    -p "${POSTGRES_SERVER_ADMIN_PASSWORD}" \
    --public-network-access Enabled \
    --sku-name GP_Gen5_2 \
    --version 11

az postgres db create \
    -g "${RG_NAME}" \
    -s "${POSTGRES_SERVER_NAME}" \
    -n "${POSTGRES_DB_NAME}"

# Create SA for Function App
az storage account create -n "${STORAGE_ACCOUNT_NAME}" --location "${LOCATION}" -g "${RG_NAME}" --sku Standard_LRS

az servicebus namespace create \
    -n "servicebus-${SUFFIX}" \
    -g "${RG_NAME}" \
    -l "${LOCATION}"

az servicebus queue create \
    -n "notificationqueue" \
    -g "${RG_NAME}" \
    --namespace-name "servicebus-${SUFFIX}"

az appservice plan create \
    -n "asp" \
    -g "${RG_NAME}" \
    --is-linux \
    --number-of-workers 1 \
    --sku B1 \
    --location "${LOCATION}"

az webapp up \
    -n "${WEB_APP_NAME}" \
    -g "${RG_NAME}" \
    -r PYTHON:3.8 \
    -p "frontend_asp" \
    --sku F1 \
    --os-type Linux

# Create Function App

az functionapp create \
    -n "${FUNCTION_APP_NAME}" \
    -g "${RG_NAME}" \
    --plan "asp" \
    --runtime python \
    --runtime-version 3.8 \
    --functions-version 4 \
    --os-type linux \
    -s "${STORAGE_ACCOUNT_NAME}"

cd function  || exit
source .venv/bin/activate
python -m pip install -r requirements.txt
func azure functionapp publish "function-${SUFFIX}" --python --build remote
cd .. || exit
