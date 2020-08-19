#!/usr/bin/env bash
set -e
HERE=$(dirname $0)
. $HERE/common

export PG_TEST_MODE=1
$HERE/start.sh $GIT_ID
$HERE/stop.sh
