FROM alpine:3.2

ENV SOCKET_DIR /root/.ssh
ENV SSH_AUTH_SOCK ${SOCKET_DIR}/socket
RUN apk add --update openssh && rm -rf /var/cache/apk/*
COPY run.sh /run.sh
VOLUME ${SOCKET_DIR}
ENTRYPOINT ["/run.sh"]
CMD ["ssh-agent"]
