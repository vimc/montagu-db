#!/usr/bin/env bash
echo "This will destroy all data in the annex, with no possibility to restore"
read -r -p "Are you sure you want to delete the data? [yes/No] " response
response=${response:l} #tolower
if [[ $response = yes ]]; then
    echo "Destroying annex"
    docker stop montagu_db_annex
    docker rm montagu_db_annex
    docker volume rm montagu_db_annex_volume
else
    echo "Not deleting anything!"
    exit 1
fi
