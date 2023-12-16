#!/usr/bin/env bash

# This file contains the variables used in the project.

SUFFIX="es81dec2023" # for resources that need a unique name
export RG_NAME="nd081-project-03-migrate-app-to-azure-rg"
export LOCATION="eastus"

# SA naming: Only lowercase letters and numbers, 3-24 characters
# and unique across all existing storage account names in Azure!!
export STORAGE_ACCOUNT_NAME="sa${SUFFIX}"

export POSTGRES_SERVER_NAME="postgres-server-${SUFFIX}"
export POSTGRES_DB_NAME=techconfdb

export POSTGRES_SERVER_ADMIN="postgresadmin"
export POSTGRES_SERVER_ADMIN_PASSWORD="P@ssw0rd1234"


# Frontend
export WEB_APP_NAME="frontend-${SUFFIX}"

# Function
export FUNCTION_APP_NAME="function-${SUFFIX}"

# use azure devops api to download subfolder from a repo abc on branch develop
# https://docs.microsoft.com/en-us/rest/api/azure/devops/git/items/get?view=azure-devops-rest-5.1
