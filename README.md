#Docker Swarm support for elasticsearch

Example:

```
docker network create --driver overlay --subnet 10.0.10.0/24 --opt encrypted elastic_cluster
docker service create --name elasticsearch --network=elastic_cluster --replicas 3 \
    --env SERVICE_NAME=elasticsearch \
    agoryachev/docker-swarm-elasticsearch
```
