#!/usr/bin/env bash
docker build -f SchemaSpy.Dockerfile --tag schemaspy .
docker run schemaspy \
    -host localhost \
    -db montagu \
    -u vimc \
    -p changeme \
    -s public \
    -o /tmp