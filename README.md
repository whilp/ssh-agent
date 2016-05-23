# ssh-agent

ssh-agent in a container.

## Usage

### 1. Run a long-lived container named `ssh-agent`. 

This container declares a volume that hosts the agent's socket so that other invocations of the `ssh` client can interact with it. Specify a UID if you would like non-root `ssh` clients in other containers to be able to connect.

```console
docker run -u 1001 -d --name=ssh-agent whilp/ssh-agent:latest
```

### 2. Add your ssh keys

Run a temporary container which has access to both the volumes from the long-lived `ssh-agent` container as well as a volume mounted from your host that includes your SSH keys. This container will only be used to load the keys into the long-lived `ssh-agent` container. Run the following command once for each key you wish to make available through the `ssh-agent`:

```console
docker run -u 1001 --rm --volumes-from=ssh-agent -v ~/.ssh:~/.ssh -it whilp/ssh-agent:latest ssh-add ~/.ssh/id_rsa
```

### 3. Access via other containers

Now, other containers can access the keys via the `ssh-agent` by setting the `SSH_AUTH_SOCK` environment variable.

#### Example 1 - List Keys

```console
docker run --rm -it --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/ssh/auth/sock ubuntu /bin/bash -c "apt-get install -y openssh-client && ssh-add -l"
```

## Notes

- this container provides `ssh-agent` support; other common `ssh` functionality (including `known_hosts` management) is out of scope

## Compatibility

This approach is tested with:

- OSX / Virtualbox / docker-machine
- OSX / docker for mac
