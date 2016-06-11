# ssh-agent

ssh-agent in a container.

## Usage

### Run a long-lived container named `ssh-agent`. 

This container declares a volume that hosts the agent's socket so that other invocations of the `ssh` client can interact with it. Specify a UID if you would like non-root `ssh` clients in other containers to be able to connect.

```console
docker run -u 1001 -d -v ssh:/ssh --name=ssh-agent whilp/ssh-agent:latest
```

### Add your ssh keys

Run a temporary container which has access to both the volumes from the long-lived `ssh-agent` container as well as a volume mounted from your host that includes your SSH keys. This container will only be used to load the keys into the long-lived `ssh-agent` container. Run the following command once for each key you wish to make available through the `ssh-agent`:

```console
docker run -u 1001 --rm -v ssh:/ssh -v $HOME:$HOME -it whilp/ssh-agent:latest ssh-add $HOME/.ssh/id_rsa
```

### Access via other containers

Now, other containers can access the keys via the `ssh-agent` by setting the `SSH_AUTH_SOCK` environment variable. For convenience, containers that have access to the volume containing `SSH_AUTH_SOCK` can configure their environment using `runit`'s `chpst` tool:

```console
docker run --rm -v ssh:/ssh -it alpine:edge /bin/sh -c "apk --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing add runit && chpst -e /ssh/env /usr/bin/env | grep SSH_AUTH_SOCK"
fetch http://dl-cdn.alpinelinux.org/alpine/edge/testing/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/edge/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/edge/community/x86_64/APKINDEX.tar.gz
(1/1) Installing runit (2.1.2-r3)
  0% [                                           ]78  1% [                                           ]78 10% [####                                       ]78 17% [#######                                    ]78 24% [##########                                 ]78 36% [###############                            ]78 51% [######################                     ]78 62% [##########################                 ]78 72% [###############################            ]78 82% [###################################        ]78100% [###########################################]78Executing busybox-1.24.2-r2.trigger
OK: 5 MiB in 12 packages
SSH_AUTH_SOCK=/ssh/auth/sock
```

## Examples

### List Keys

```console
docker run --rm -it -v ssh:/ssh -e SSH_AUTH_SOCK=/ssh/auth/sock ubuntu /bin/bash -c "apt-get install -y openssh-client && ssh-add -l"
```

## Notes

- this container provides `ssh-agent` support; other common `ssh` functionality (including `known_hosts` management) is out of scope

## Compatibility

This approach is tested with:

- OSX / Virtualbox / docker-machine
- OSX / docker for mac
