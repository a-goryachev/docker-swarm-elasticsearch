FROM elasticsearch

RUN apt-get -y update; apt-get install dnsutils

ENTRYPOINT /swarm-entrypoint.sh
