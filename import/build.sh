set -ex

GIT_ID=$(git rev-parse --short=7 HEAD)
GIT_BRANCH=$(git symbolic-ref --short HEAD)
ORG=vimc
NAME=montagu-db-import

TAG=$ORG/$NAME
COMMIT_TAG=$ORG/$NAME:$GIT_ID
BRANCH_TAG=$ORG/$NAME:$GIT_BRANCH
DB=$ORG/montagu-db:$GIT_ID

docker build \
       --tag $COMMIT_TAG \
       --tag $BRANCH_TAG \
       .

docker push $COMMIT_TAG
docker push $BRANCH_TAG
