FROM alpine:3.1
LABEL Name=davyj-ao-training-api
LABEL Version=0.1.0
ENV VAULT_VERSION 0.8.1

MAINTAINER DavyJ0nes <davy.jones@me.com>

RUN apk update \
  && apk add -q ca-certificates \
  && update-ca-certificates \
  && apk add -q wget
RUN wget -O /tmp/vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
  && unzip -d /bin /tmp/vault.zip \
  && chmod 755 /bin/vault \
  && rm /tmp/vault.zip
ADD vault-init.sh /
ADD vault-demo-example /
CMD ["./vault-demo-example"]
