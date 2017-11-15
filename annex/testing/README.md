## Development

Notes and testing for the annex.  This can be removed as we stabilise things.

With the montagu dump in `/tmp/import.dump`, run `./annex.sh` script and it will work through:

1. setting up a pair of postgres docker containers
2. import our existing data into the main db
3. do the schema migrations which sets up the foreign data connection
4. import some data into the annex
5. confirm that data is reachable from the main db

### Interaction with montagu

Adding the annex into the mix considerably complicates deployment, though once running it should not be that much trouble.  I can see three modes that correspond to configuration settings in `montagu`:

1. `testing`
   * add a local (empty) copy of the annex into the docker compose mix
   * scramble passwords if `use_real_passwords` is set (but practically they won't be)
   * always perform schema migrations (because starting from an empty db)

2. `production`
   * always perform schema migrations (because this is how changes are applied)
   * retrieve password from vault (implying `use_real_passwords`)
   * don't set the password - not sure how we'd want to change the pw actually

3. `readonly`
   * **never** perform schema migrations (because that would affect the production copy of montagu).  This means that schema migrations for the annex database are going to be a bit of a trick as we may have to take down science/uat if they are interacting with the stochastic estimates
  * retrieve password from vault (implying `use_real_passwords`)
