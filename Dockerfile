FROM docker.io/library/debian:stable

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install git nodejs npm curl -y && \
    apt-get clean && \
    npm install -g @appthreat/cdxgen && \
    mkdir /data && \
    chown 1000:1000 /data && \
    chmod 555 /entrypoint.sh

WORKDIR /data
USER 1000

ENTRYPOINT ["/entrypoint.sh"]
