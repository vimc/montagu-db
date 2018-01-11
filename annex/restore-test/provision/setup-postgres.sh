#!/bin/sh
set -ex

if which -a psql > /dev/null; then
    echo "psql is already installed"
else
    echo "Installing psql"

    repo="deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
    echo $repo | sudo tee /etc/apt/sources.list.d/pgdg.list

    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
        sudo apt-key add -
    sudo apt-get update 

    sudo apt-get install -y postgresql-client-9.6 
fi
