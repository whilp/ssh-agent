# ssh-agent

ssh-agent in a container.

## Usage

First, run a new container with `ssh-agent` that has access to your SSH keys via a volume. `exec` `ssh-add` in that container (named `ssh-agent` for convenience) to add as many keys as you'd like.

```
docker run --rm --name ssh-agent -v ~/.ssh:/root/.ssh whilp/ssh-agent:latest
docker exec -it ssh-agent ssh-add /root/.ssh/id_rsa
```

You should now be able to run an image with an SSH client installed:

```
docker run --rm -it --volumes-from=ssh-agent -e SSH_AUTH_SOCK=/ssh-agent/socket ssh-client ssh-add -l
```
