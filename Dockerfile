FROM docker.elastic.co/elasticsearch/elasticsearch:5.2.2

USER root

RUN apk update && apk add bind-tools

COPY swarm-entrypoint.sh /

USER elasticsearch

ENTRYPOINT ["/swarm-entrypoint.sh"]
