# Adjusting the synthetic data

Get set up with:

```
docker volume rm montagu-data-synthetic 2> /dev/null || true
./scripts/create-empty.sh montagu-data-synthetic
docker run --rm \
    -v montagu-data-synthetic:/var/lib/postgresql/data \
    --name montagu-db-devel-synthetic \
    -p 8888:5432 \
    vimc/montagu-db
```


```
source("synthetic.R")
```
