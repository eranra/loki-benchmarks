#!/bin/bash

set -eou pipefail

BUCKET_NAME=$1

REGION=$(aws configure get region)

delete_bucket() {
    aws s3 rb s3://"$BUCKET_NAME" --region "$REGION" --force  || true
}

create_bucket() {
    if [[ "$REGION" = "us-east-1" ]]; then
        aws s3api create-bucket \
            --acl private \
            --bucket "$BUCKET_NAME" \
            --region "$REGION"
    else
        aws s3api create-bucket \
            --acl private \
            --bucket "$BUCKET_NAME" \
            --region "$REGION" \
            --create-bucket-configuration LocationConstraint="$REGION"
    fi
}

block_public_access_to_bucket() {
    aws s3api put-public-access-block \
        --bucket "$BUCKET_NAME" \
        --region "$REGION" \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true" || true
}

main() {
  echo "deleting bucket $BUCKET_NAME (if exists)"
  delete_bucket
  echo "creating bucket $BUCKET_NAME"
  create_bucket
  block_public_access_to_bucket
}

main
