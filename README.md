# ssh-agent

ssh-agent in a container.

## Usage

First, run a long-lived container named `ssh-agent`. This container declares a volume that hosts the agent's socket so that other invocations of the `ssh` client can interact with it.

```console
docker run -d --name=ssh-agent whilp/ssh-agent:latest
```

Then, run a temporary container which has access to both the volumes from the long-lived `ssh-agent` container as well as a volume mounted from your host that includes your SSH keys. This container will only be used to load the keys into the long-lied `ssh-agent` container. Run the following command once for each key you wish to make available through the `ssh-agent`:

```console
docker run --rm --volumes-from=ssh-agent -v ~/.ssh:/ssh -it whilp/ssh-agent:latest ssh-add /ssh/
```

Now, other containers can access the keys via the `ssh-agent` by setting the `SSH_AUTH_SOCK` environment variable:

```
docker run --rm -it --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/ssh-agent/socket ubuntu ssh-add -l
```
