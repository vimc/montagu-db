#!/bin/sh

set -x

if which -a docker > /dev/null; then
    echo "docker is already installed"
else
    echo "installing docker"
    # The big docker directory is /var/lib/docker - we'll move that
    # out onto the external disk:
    mkdir -p /mnt/data/docker/var-lib-docker
    ln -s /mnt/data/docker/var-lib-docker /var/lib/docker

    # Then continue with the installation
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
fi

if getent passwd teamcity > /dev/null; then
    if id -Gn teamcity | grep -qv "\bdocker\b"; then
        echo "Adding teamcity to the docker group"
        sudo usermod -aG docker teamcity
    fi
fi
