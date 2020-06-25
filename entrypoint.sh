#!/usr/bin/env bash

if [[ -z "$PULUMI_ACCESS_TOKEN" ]]; then 
  echo >&2 "ERROR : PULUMI_ACCESS_TOKEN must be set"
  exit 1
fi

set -euo pipefail
IFS=$'\n\t'

function output {
  echo "::set-output name=$1::$2"
}

branch=$(git rev-parse --abbrev-ref HEAD)
stack=$(echo $branch | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g')

output Branch "$branch"
output Stack "$stack"
