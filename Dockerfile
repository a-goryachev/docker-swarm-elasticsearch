FROM elasticsearch

RUN apt-get -y update; apt-get -y install dnsutils

ENTRYPOINT /swarm-entrypoint.sh
