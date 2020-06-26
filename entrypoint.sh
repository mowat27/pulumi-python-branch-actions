#!/usr/bin/env bash

# We only accept AWS credentials from environment variables.  This is fine 
# because the container does not include the aws cli so no profiles will be 
# available.
# We only require and access key and secret as a sanity check.  It's up to the 
# caller to attend to other details such as session tokens and regions depending
# on their own context.
if [[ -z "$PULUMI_ACCESS_TOKEN" ]]; then 
  echo >&2 "ERROR : PULUMI_ACCESS_TOKEN must be set"
  exit 1
fi




# Access token is needed in order to run Pulumi commands
if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY"]]; then 
  cat >&2 <<EOF 
ERROR : AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be set.
        
        AWS_SESSION_TOKEN should also be be provided if you are assuming a role.
        
        You may also consider setting AWS_DEFAULT_REGION but that can also 
        be supplied using Pulumi's stack config.
EOF
  exit 1
fi

# Enter bash strict mode
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

function output {
  echo "::set-output name=$1::$2"
}

branch=$(git rev-parse --abbrev-ref HEAD)
stack=${PULUMI_STACK:-$(echo "$branch" | 
                        tr '[:upper:]' '[:lower:]' | 
                        sed -E 's/[^a-z0-9]+/-/g')}

action=$1; shift
if [[ -z $action ]]; then 
  echo >&2 "Please pass up, down or a command to run"
fi

case "$action" in 
  # Create stack and deploy resources
  # This is run on push
  "up")
    pulumi stack select --create "$stack" "$@"
    pulumi up --yes
    output PulumiStackOutput "$(pulumi stack output --json)"
    ;;
  
  # Destroy all resources and delete stack
  # This would be run when the branch is deleted
  "down")
    pulumi destroy --yes --stack "$stack"
    pulumi stack rm --yes --stack "$stack"
    ;;
  *)
    exec "$action" "$@"
esac

output GitBranch "$branch"
output PulumiStack "$stack"
