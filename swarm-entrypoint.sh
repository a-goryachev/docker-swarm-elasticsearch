#!/bin/bash

set -e

if [ -z ${SERVICE_NAME} ];then
    >&2 echo "Environment variable SERVICE_NAME not set. You MUST set it to name of docker swarm service"
fi

# Docker swarm's DNS resolves special hostname "tasks.<service_name" to IP addresses of all containers inside overlay network
SWARM_SERVICE_IPs=$(dig tasks.${SERVICE_NAME} +short)
echo "$SWARM_SERVICE_IPs"
MY_IP=$(dig $(hostname) +short)

OTHER_NODES=""

echo "Discovering other nodes in cluster..."
for NODE_IP in $SWARM_SERVICE_IPs
do
    if [ "${NODE_IP}" == "${MY_IP}" ];then
        continue;
    fi
    echo "${NODE_IP}"
    OTHER_NODES="${OTHER_NODES}${NODE_IP},"
done

echo $OTHER_NODES
# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
    set -- -Dnetwork.publish_host=${MY_IP} "$@"
    set -- -Dnetwork.host=${MY_IP} "$@"

    if ! [ -z ${OTHER_NODES} ];then
        set -- elasticsearch -Ddiscovery.zen.ping.unicast.hosts=${OTHER_NODES%,} "$@"
    else
        echo "No other nodes in the cluster. I am a first one."
        set -- elasticsearch "$@"
    fi
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
    # Change the ownership of user-mutable directories to elasticsearch
    for path in \
	/usr/share/elasticsearch/data \
	/usr/share/elasticsearch/logs \
    ; do
	chown -R elasticsearch:elasticsearch "$path"
    done
    
    set -- gosu elasticsearch "$@"
    #exec gosu elasticsearch "$BASH_SOURCE" "$@"
fi

# As argument is not related to elasticsearch,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"