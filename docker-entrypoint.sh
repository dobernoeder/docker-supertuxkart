#!/bin/bash
set -e

if [ ${#} -gt "0" ]
then
  ADDITIONAL_PARAMETERS="${@}"" "
else
  ADDITIONAL_PARAMETERS=""
fi

cp /stk/server_config.xml /tmp/server_active_config.xml

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
if [[ -n ${USERNAME} && -n ${PASSWORD} ]]
then
    ADDITIONAL_PARAMETERS=$(echo "$ADDITIONAL_PARAMETERS --init-user --login=${USERNAME} --password=${PASSWORD}")
fi

# Start the server
if [[ -n ${SERVER_PASSWORD} && ! -n ${IS_KI_SERVER} ]]
then
    nr=$(cat /tmp/server_active_config.xml | grep -n private-server-password | cut -d':' -f1)
    if [[ -n ${nr} ]]
    then
       sed -i "/^\s*<private-server-password/c\    <private-server-password value=\"${SERVER_PASSWORD}\" />" /tmp/server_active_config.xml
    else 
       nr=$(cat /tmp/server_active_config.xml | wc -l)
       nr=$(( $nr - 2 ))
       sed -i "${nr}i\    <private-server-password value=\"${SERVER_PASSWORD}\" />" /tmp/server_active_config.xml
    fi
fi

if [[ -n ${IS_KI_SERVER} ]]
then
  if [[ -n ${KI_COUNT} ]]
  then
    KI_COUNT=3
  fi
  if [[ -n ${SERVER_ADDRESS} ]] 
  then
    SERVER_ADDRESS="127.0.0.1:2759"
  fi
  supertuxkart --network-ai=${KI_COUNT} --connect-now=${SERVER_ADDRESS} --server-password=${SERVER_PASSWORD}
else
  supertuxkart --server-config=/tmp/server_active_config.xml "${ADDITIONAL_PARAMETERS}"
fi
