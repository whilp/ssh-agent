#!/bin/sh

case "$1" in
    ssh-agent)
        auth_dir=$(dirname "${SSH_AUTH_SOCK}")
        env_dir=$(dirname "${auth_dir}")/env
        rm -f "${SSH_AUTH_SOCK}"
        mkdir -p "${auth_dir}"
        chmod 700 "${auth_dir}"

        # Create an envdir such that `chpst -e /ssh/env /bin/sh` works.
        rm -rf "${env_dir}"
        mkdir -p "${env_dir}"
        echo "${SSH_AUTH_SOCK}" > "${env_dir}/SSH_AUTH_SOCK"

        exec /usr/bin/ssh-agent -a "${SSH_AUTH_SOCK}" -D
        ;;
    *)
        exec $@;;
esac
