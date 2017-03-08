FROM docker.elastic.co/elasticsearch/elasticsearch:5.2.2

RUN apk update && apk add bind-tools

COPY swarm-entrypoint.sh /

ENTRYPOINT ["/swarm-entrypoint.sh"]
