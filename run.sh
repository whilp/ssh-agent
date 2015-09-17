#!/bin/sh

# NOTE: openssh 6.9 introduces -D for running ssh-agent in the foreground.
exec /usr/bin/ssh-agent -a ${SSH_AUTH_SOCK} -d > /dev/null 2>&1
