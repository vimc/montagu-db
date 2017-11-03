# annex

Notes and testing for the annex.  This can be removed as we stabilise things.

With the montagu dump in `/tmp/import.dump`, run `./annex.sh` script and it will work through:

1. setting up a pair of postgres docker containers
2. import our existing data into the main db
3. do the schema migrations which sets up the foreign data connection
4. import some data into the annex
5. confirm that data is reachable from the main db
