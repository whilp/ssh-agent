#!/bin/sh

case "$1" in
    ssh-agent)
        exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -D > /dev/null 2>&1
        ;;
    *)
        exec $@;;
esac
