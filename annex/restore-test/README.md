# Annex restore test
Run `./test-annex-restore.sh`. This will:

1. Require your Vault GitHub token
1. Create a VM using Vagrant, and restore the annex backup into a
   Montagu db container inside the VM.
1. Dump some of the most recent rows from this restored database,
   and also from the live annex, to text files.
1. Compare these text files with `diff`

You can then either ssh into the VM to poke around a bit more (`vagrant ssh`)
or teardown the VM with `./teardown.sh`.
