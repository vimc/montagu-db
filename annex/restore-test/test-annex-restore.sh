#!/usr/bin/env bash
set -ex

REAL_ANNEX_HOST=annex.montagu.dide.ic.ac.uk
REAL_ANNEX_PORT=15432

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
vault auth -method=github

# --------------------------------------------------------------------
# Restore backup (inside VM)
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
# Pull data from the real annex and from our copy restored from backup
# --------------------------------------------------------------------
set +x
export PGPASSWORD=$(vault read -field=value secret/annex/password)

set -x
test_query="SELECT * FROM burden_estimate_stochastic 
ORDER BY id DESC LIMIT 5000;"

psql -h localhost -p 15433 -U vimc -d montagu \
    -c "$test_query" > from_backup
psql -h $REAL_ANNEX_HOST -p $REAL_ANNEX_PORT -U vimc -d montagu \
    -c "$test_query" > from_live

# --------------------------------------------------------------------
# Compare the data and check there are no diffs
# --------------------------------------------------------------------
set +ex
diff from_live from_backup
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
