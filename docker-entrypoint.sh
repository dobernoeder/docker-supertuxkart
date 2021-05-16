#!/bin/bash
set -e

/bin/cp /stk/server_config.xml /stk/current_server_config.xml

ADDITIONAL_PARAMETERS=""

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



# Log in with username and password if given
if [ -n ${USERNAME} -a -n ${PASSWORD} ]
then
    ADDITIONAL_PARAMETERS=" --init-user --login=${USERNAME} --password=${PASSWORD}"
fi

# Start the server
if [ -n ${SERVER_PASSWORD} ]
then
    ADDITIONAL_PARAMETERS=" --server-password=${SERVER_PASSWORD}"
fi

supertuxkart --server-config=current_server_config.xml ${ADDITIONAL_PARAMETERS}
