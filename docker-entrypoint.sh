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
if [ -f /stk/USERNAME ]
then
  USERNAME=$(cat /stk/USERNAME)
fi

if [ -f /stk/PASSWORD ]
then
  PASSWORD=$(cat /stk/PASSWORD)
fi

if [ -f /stk/SERVER_PASSWORD ]
then
  SERVER_PASSWORD=$(cat /stk/SERVER_PASSWORD)
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
if [ -f /stk/secrets/USERNAME ]
then
  USERNAME=$(cat /stk/secrets/USERNAME)
fi

if [ -f /stk/secrets/PASSWORD ]
then
  PASSWORD=$(cat /stk/secrets/PASSWORD)
fi

if [ -f /stk/secrets/SERVER_PASSWORD ]
then
  SERVER_PASSWORD=$(cat /stk/secrets/SERVER_PASSWORD)
fi



# Log in with username and password if given
if [ -n ${USERNAME} -a -n ${PASSWORD} ]
then
    ADDITIONAL_PARAMETERS=$(echo "$ADDITIONAL_PARAMETERS --init-user --login=${USERNAME} --password=${PASSWORD}")
fi

# Start the server
if [ -n ${SERVER_PASSWORD} ]
then
    nr=$(cat /stk/server_active_config.xml | grep -n private-server-password | cut -d':' -f1)
    if [[ -n ${nr} ]]
    then
       sed -i "/^\s*<private-server-password/c\    <private-server-password value=\"${SERVER_PASSWORD}\" />" /stk/server_active_config.xml
    else
       nr=$(cat /stk/server_active_config.xml | wc -l)
       nr=$(( $nr - 2 ))
       sed -i "${nr}i\    <private-server-password value=\"${SERVER_PASSWORD}\" />" /stk/server_active_config.xml
    fi
fi

supertuxkart --server-config=/stk/server_active_config.xml "${ADDITIONAL_PARAMETERS}"
