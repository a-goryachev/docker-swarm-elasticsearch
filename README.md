#Docker Swarm support for elasticsearch

Example:

```
docker network create --driver overlay --subnet 10.0.10.0/16 --opt encrypted elastic_cluster
docker service create --name elasticsearch --network=elastic_cluster --replicas 3 \
    -e SERVICE_NAME=elasticsearch \
    -e cluster.name=docker-cluster \
    -e "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
    agoryachev/docker-swarm-elasticsearch
```
