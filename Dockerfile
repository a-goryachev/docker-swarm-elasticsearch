FROM docker.elastic.co/elasticsearch/elasticsearch:5.5.1

USER root

RUN yum install -y bind-utils
COPY es-docker /usr/share/elasticsearch/bin/
USER elasticsearch
