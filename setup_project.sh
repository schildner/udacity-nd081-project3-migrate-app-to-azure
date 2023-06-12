#!/usr/bin/env bash

YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

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
    --sku-name B_Gen5_1 \
    --version 11


az postgres db create \
    -g "${RG_NAME}" \
    -s "${POSTGRES_SERVER_NAME}" \
    -n "${POSTGRES_DB_NAME}"

# Create Function App
az storage account create -n "${STORAGE_ACCOUNT_NAME}" --location "${LOCATION}" -g "${RG_NAME}" --sku Standard_LRS

az appservice plan create \
    -n "asp" \
    -g "${RG_NAME}" \
    --is-linux \
    --number-of-workers 1 \
    --sku B1 \
    --location "${LOCATION}"

az servicebus namespace create \
    -n "servicebus-${SUFFIX}" \
    -g "${RG_NAME}" \
    -l "${LOCATION}"

az servicebus queue create \
    -n "notificationqueue" \
    -g "${RG_NAME}" \
    --namespace-name "servicebus-${SUFFIX}"

az webapp up \
    -n "${WEB_APP_NAME}" \
    -g "${RG_NAME}" \
    -r PYTHON:3.8 \
    -p asp \
    --sku F1 \
    --os-type Linux