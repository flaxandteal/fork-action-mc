#!/bin/sh -l
set -euo pipefail

MC_ALIAS=${MC_ALIAS:="s3"}
MC_URL=${MC_URL:="https://s3.amazonaws.com"}
MC_API_SIGNATURE=${MC_API_SIGNATURE:="S3v4"}
MC_BUCKET_LOOKUP=${MC_BUCKET_LOOKUP:="auto"}

# Set mc configuration
mc alias set "$MC_ALIAS" "$MC_URL" "$AWS_ACCESS_KEY_ID" "$AWS_SECRET_ACCESS_KEY" --api "$MC_API_SIGNATURE" --lookup "$MC_BUCKET_LOOKUP"

# Execute mc by expanding passed params and passing them to mc itself
mc $*
