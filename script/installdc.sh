#!/bin/bash
adirScript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt-get update
apt-get install wget
wget -qO- https://get.docker.com/ | sh
usermod -aG docker ubuntu
service docker start
#newgrp docker

dockerComposeVersion=1.25.4
curl -L "https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#apt-get install git


