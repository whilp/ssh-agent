#!/bin/sh

case "$1" in
    ssh-agent)
        # NOTE: openssh 6.9 introduces -D for running ssh-agent in the foreground.
        [[ -e ${SSH_AUTH_SOCK} ]] && rm ${SSH_AUTH_SOCK}
        exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -d
        ;;
    *)
        exec $@;;
esac
