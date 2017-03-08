FROM docker.elastic.co/elasticsearch/elasticsearch:5.2.2

USER root

RUN apk update && apk add bind-tools
COPY es-docker /usr/share/elasticsearch/bin/
USER elasticsearch
