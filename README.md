# ssh-agent

ssh-agent in a container.

## Usage

### 1. Run a long-lived container named `ssh-agent`. 

This container declares a volume that hosts the agent's socket so that other invocations of the `ssh` client can interact with it.

```console
docker run -d --name=ssh-agent whilp/ssh-agent:latest
```

### 2. Add your ssh keys

Run a temporary container which has access to both the volumes from the long-lived `ssh-agent` container as well as a volume mounted from your host that includes your SSH keys. This container will only be used to load the keys into the long-lived `ssh-agent` container. Run the following command once for each key you wish to make available through the `ssh-agent`:

```console
docker run --rm --volumes-from=ssh-agent -v ~/.ssh:/ssh -it whilp/ssh-agent:latest ssh-add /ssh/<host_key_file_name>
```

### 3. (optional) Add known_hosts

`Host key verification failed` is common if `known_hosts` are not setup.  Hosts such as `github.com` or `bitbucket.org` will require host key validation.  Follow this step to copy any `known_hosts` from your `host` to the `ssh-agent`. 

```console
docker run --rm --volumes-from=ssh-agent -v ~/.ssh:/ssh -it whilp/ssh-agent:latest cp /ssh/known_hosts /root/.ssh/known_hosts
```

### 4. Access via other containers

Now, other containers can access the keys via the `ssh-agent` by setting the `SSH_AUTH_SOCK` environment variable.

#### Example 1 - List Keys

```console
docker run --rm -it --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/root/.ssh/socket ubuntu ssh-add -l
```

#### Example 2 - Test `known_hosts`

Test optional `known_hosts` configuration (assuming you followed step 3 above and have Github keys setup)

```console
docker run --rm -it --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/root/.ssh/socket ubuntu apt-get install -y openssh-client && ssh -T git@github.com
```

## Compatibility

This approach is tested with:

- OSX / Virtualbox / docker-machine
