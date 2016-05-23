#!/bin/sh

case "$1" in
    ssh-agent)
        rm -f "${SSH_AUTH_SOCK}"
        mkdir -p $(dirname "${SSH_AUTH_SOCK}")
        chmod 700 $(dirname "${SSH_AUTH_SOCK}")
        exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -D > /dev/null 2>&1
        ;;
    *)
        exec $@;;
esac
