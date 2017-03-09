Docker Swarm support for elasticsearch
--------------------------------------

Automatically configures elasticsearch to connect other nodes inside docker swarm cluster.
==========================================================================================

Affects elasticsearch parameters:

- `network.host` - an IP address of the container
- `network.publish_host` - an IP address of the container
- `discovery.zen.ping.unicast.hosts` - a list of IP addresses other nodes inside docker swarm service

In order to run docker swarm service from this image it is REQUIRED to set environment variable SERVICE_NAME to the name of service in docker swarm.

Example:

```
docker network create --driver overlay --subnet 10.0.10.0/24 \
  --opt encrypted elastic_cluster

docker service create --name elasticsearch --network=elastic_cluster \
  --replicas 3 \
  --env SERVICE_NAME=elasticsearch \
  agoryachev/docker-swarm-elasticsearch:5.2.2
```
