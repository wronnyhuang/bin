#!/usr/bin/env bash
apt-get update
apt-get install bash-completion
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh