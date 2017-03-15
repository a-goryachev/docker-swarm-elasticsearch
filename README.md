Docker Swarm support for elasticsearch
======================================

Automatically configures elasticsearch to connect other nodes inside docker swarm cluster.
------------------------------------------------------------------------------------------

Affects elasticsearch parameters:

- `network.host` - an IP address of the container
- `network.publish_host` - an IP address of the container
- `discovery.zen.ping.unicast.hosts` - a list of IP addresses other nodes inside docker swarm service

In order to run docker swarm service from this image it is REQUIRED to set environment variable SERVICE_NAME to the name of service in docker swarm.
Please avoid to manually configure parameters listed above.

Example:

```
docker network create --driver overlay --subnet 10.0.10.0/24 \
  --opt encrypted elastic_cluster

docker service create --name elasticsearch --network=elastic_cluster \
  --replicas 3 \
  --env SERVICE_NAME=elasticsearch \
  --publish 9200:9200
  agoryachev/docker-swarm-elasticsearch:5.2.2
```

Since elasticsearch requires vm.max_map_count to be at least 262144 but docker service create does not support sysctl management you have to set 
vm.max_map_count on all your nodes to proper value BEFORE starting service.
On Linux Ubuntu: `sysctl -w "vm.max_map_count=262144"`. Or `echo "vm.max_map_count=262144" >> /etc/sysctl.conf` to set it permanently.


To access elasticsearch cluster connect to any docker swarm node to port 9200 using default credentials: `curl http://elastic:changeme@my-es-node.mydomain.com:9200`.

To change default elasticsearch parameters use environment variables. See https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html for more details.