#!/usr/bin/env bash
set -e

# --------------------------------------------------------------------
# Cleanup previous attempt
# --------------------------------------------------------------------
./teardown.sh

# --------------------------------------------------------------------
# Get access to Vault
# --------------------------------------------------------------------
export VAULT_ADDR='https://support.montagu.dide.ic.ac.uk:8200'
if [ "$VAULT_AUTH_GITHUB_TOKEN" = "" ]; then
    echo -n "Please provide your GitHub personal access token for the vault: "
    read -s token
    echo ""
    export VAULT_AUTH_GITHUB_TOKEN=${token}
fi
set -x
vault auth -method=github

# --------------------------------------------------------------------
# Restore backup (inside VM) and output sample data to shared folder
# --------------------------------------------------------------------
if ! vagrant plugin list | grep vagrant-persistent-storage; then
    vagrant plugin install vagrant-persistent-storage
fi
vagrant up

function cleanup {
    ./teardown.sh
}
trap cleanup SIGINT SIGTERM

# --------------------------------------------------------------------
# Compare the data and check there are no diffs
# --------------------------------------------------------------------
set +x
difference=$(diff shared/from_live shared/from_backup)
echo "----------------------------------------------------------------"
if [ -z difference ]; then
    echo "No differences found in most recent 5000 records."
    echo "Restore from backup was successful!"
else
    echo "Differences found in the most recent 5000 records."
    echo "Restore unsuccessful / backup is out of date."
fi

echo "VM is still running, so that you can run additional queries"
echo "to inspect the data. Use vagrant ssh and then psql on port"
echo "15432 to do so. When you are finished, teardown with "
echo "./teardown.sh."
