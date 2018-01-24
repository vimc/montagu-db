#!/bin/sh
set -ex

# Get backup repo
if [ -d "montagu-backup" ]; then
    cd montagu-backup    
    git pull
else
    git clone https://github.com/vimc/montagu-backup
    cd montagu-backup
fi

# Setup backup
mkdir -p /etc/montagu/backup
cp configs/annex/config.json /etc/montagu/backup/
./setup.sh
