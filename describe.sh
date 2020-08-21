#!/bin/bash

while getopts p:s: flag
do
    case "${flag}" in
        p) PROFILE=${OPTARG};;
        s) STACK=${OPTARG};;
    esac
done

function usage {
    echo "describe.sh -p [profile] -s [stack]" && exit 1
}

if [ -z "$PROFILE" ]; then usage; fi
if [ -z "$STACK" ]; then usage; fi

OUTPUT=$(aws --profile $PROFILE cloudformation describe-stacks --stack-name $STACK)
HTTP_ID=$(echo $OUTPUT | jq -r -c '.["Stacks"][]["Outputs"][]  | select(.OutputKey == "OutExampleApiHttpId") | .OutputValue')
HTTP_URL=$(echo $OUTPUT | jq -r -c '.["Stacks"][]["Outputs"][]  | select(.OutputKey == "OutExampleApiHttpUrl") | .OutputValue')
for var in {HTTP_ID,HTTP_URL}; do echo "$var=${!var}"; done
