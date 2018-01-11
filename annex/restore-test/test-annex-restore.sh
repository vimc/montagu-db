#!/usr/bin/env bash
set -e

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
    set +e
    vagrant destroy --force
    rm -r disk
}
trap cleanup EXIT

# --------------------------------------------------------------------
# Compare the data and check there are no diffs
# --------------------------------------------------------------------
set +ex
diff shared/from_live shared/from_backup
echo "----------------------------------------------------------------"
case $? in
    0 )
        echo "No differences found in most recent 5000 records."
        echo "Restore from backup was successful!" ;;
    1 )
        echo "Differences found in the most recent 5000 records."
        echo "Restore unsuccessful / backup is out of date." ;;
    2 )
        echo "Diff encountered an error" ;;
esac
