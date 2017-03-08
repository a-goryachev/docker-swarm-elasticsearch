FROM docker.elastic.co/elasticsearch/elasticsearch:5.2.2

RUN apt-get -y update; apt-get -y install dnsutils

COPY swarm-entrypoint.sh /

ENTRYPOINT ["/swarm-entrypoint.sh"]
