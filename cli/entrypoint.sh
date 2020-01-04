#!/bin/sh

echo "Lets test the cli action..."

set -eu

sh -c "sfdx $*"

echo "Action: cli, end of entrypoint..."

