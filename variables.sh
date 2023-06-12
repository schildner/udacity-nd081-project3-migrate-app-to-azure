#!/usr/bin/env bash

# This file contains the variables used in the project.

SUFFIX="es81" # for resources that need a unique name
RG_NAME="nd081-project-03-migrate-app-to-azure-rg"
LOCATION="eastus"

# SA naming: Only lowercase letters and numbers, 3-24 characters
# and unique across all existing storage account names in Azure!!
STORAGE_ACCOUNT_NAME="sa${SUFFIX}"

POSTGRES_SERVER_NAME="postgres-server-${SUFFIX}"
POSTGRES_DB_NAME=techconfdb

POSTGRES_SERVER_ADMIN="postgresadmin"
POSTGRES_SERVER_ADMIN_PASSWORD="P@ssw0rd1234"


# Frontend
WEB_APP_NAME="frontend-${SUFFIX}"

# Function
FUNCTION_APP_NAME="function-${SUFFIX}"