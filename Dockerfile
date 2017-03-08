FROM elasticsearch

RUN apt-get -y update; apt-get -y install dnsutils

COPY swarm-entrypoint.sh /

ENTRYPOINT ["/swarm-entrypoint.sh"]
