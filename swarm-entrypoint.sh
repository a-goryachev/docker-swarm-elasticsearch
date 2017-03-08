#!/bin/bash

#set -e

echo "service name: ${SERVICE_NAME}"
if [ -z ${SERVICE_NAME} ];then
    echo "Environment variable SERVICE_NAME not set. You MUST set it to name of docker swarm service"
    #exit 1
fi

echo "Discovering other nodes in cluster..."
# Docker swarm's DNS resolves special hostname "tasks.<service_name" to IP addresses of all containers inside overlay network
SWARM_SERVICE_IPs=$(dig tasks.${SERVICE_NAME} +short)
echo "dig exit code: $?"
echo "nodes of service ${SERVICE_NAME}: $SWARM_SERVICE_IPs"
MY_IP=$(dig $(hostname) +short)
echo "My IP: ${MY_IP}"

OTHER_NODES=""

for NODE_IP in $SWARM_SERVICE_IPs
do
    if [ "${NODE_IP}" == "${MY_IP}" ];then
        continue;
    fi
    echo "${NODE_IP}"
    OTHER_NODES="${OTHER_NODES}${NODE_IP},"
done

set_env=""
if ! [ -z ${MY_IP} ];then
    echo "Exporting publishhost and host"
    set_env="$set_env ""network.publish_host=${SERVICE_NAME}"""
    set_env="$set_env ""network.host=${MY_IP}"""
fi
if ! [ -z $OTHER_NODES ];then
    echo "Exporting environment variables"
    set_env="$set_env ""discovery.zen.ping.unicast.hosts=${OTHER_NODES%,}"""
fi

env $set_env bash -c "$@"