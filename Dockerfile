FROM docker.elastic.co/elasticsearch/elasticsearch:5.4.0

USER root

RUN apk update && apk add bind-tools
COPY es-docker /usr/share/elasticsearch/bin/
USER elasticsearch
