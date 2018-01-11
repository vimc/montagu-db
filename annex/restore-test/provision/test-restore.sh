#!/bin/sh
set -ex

# Restore from backup
cd montagu-backup
./restore.py
