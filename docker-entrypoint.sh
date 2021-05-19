#!/bin/bash
set -e

ADDITIONAL_PARAMETERS=""

# Check for Secrets provided by Kubernetes
if [ -f /stk/username ]
then
  USERNAME=$(cat /stk/username)
fi

if [ -f /stk/password ]
then
  PASSWORD=$(cat /stk/password)
fi

if [ -f /stk/server_password ]
then
  SERVER_PASSWORD=$(cat /stk/server_password)
fi

# Check for Secrets in subfolder provided by Kubernetes
if [ -f /stk/secrets/username ]
then
  USERNAME=$(cat /stk/secrets/username)
fi

if [ -f /stk/secrets/password ]
then
  PASSWORD=$(cat /stk/secrets/password)
fi

if [ -f /stk/secrets/server_password ]
then
  SERVER_PASSWORD=$(cat /stk/secrets/server_password)
fi




# Log in with username and password if given
if [ -n ${USERNAME} -a -n ${PASSWORD} ]
then
    ADDITIONAL_PARAMETERS=$(echo "$ADDITIONAL_PARAMETERS --init-user --login=${USERNAME} --password=${PASSWORD}")
fi

# Start the server
if [ -n ${SERVER_PASSWORD} ]
then
    ADDITIONAL_PARAMETERS=$(echo "$ADDITIONAL_PARAMETERS --server-password=${SERVER_PASSWORD}")
fi

supertuxkart --server-config=/stk/server_config.xml "${ADDITIONAL_PARAMETERS}"
