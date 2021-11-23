FROM docker.io/library/debian:stable

COPY entrypoint.sh /entrypoint.sh

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install git curl -y && \
    curl -fsSL https://deb.nodesource.com/setup_17.x | bash - && \
    apt-get install -y nodejs jq && \
    apt-get clean && \
    npm install -g @appthreat/cdxgen && \
    mkdir /data && \
    chown 1000:1000 /data && \
    chmod 555 /entrypoint.sh

WORKDIR /data
USER 1000

ENTRYPOINT ["/entrypoint.sh"]
