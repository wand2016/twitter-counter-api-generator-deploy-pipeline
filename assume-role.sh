#!/bin/bash

unset AWS_SESSION_TOKEN
export AWS_REGION=ap-northeast-1

temp_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::646279979860:role/twitter-counter-api-generator-deploy-pipeline-deploy" \
                    --role-session-name "session_name")

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

aws sts get-caller-identity
