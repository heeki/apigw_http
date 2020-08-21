#!/bin/bash

while getopts p:t:s:v:b: flag
do
    case "${flag}" in
        p) PROFILE=${OPTARG};;
        t) TEMPLATE=${OPTARG};;
        s) STACK=${OPTARG};;
        v) VERB=${OPTARG};;
        b) BUILD=${OPTARG};;
    esac
done

function usage {
    echo "deploy.sh -p [profile] -t [template_file] -s [stack_name] -v [deploy|local] -b [true|false]" && exit 1
}

if [ -z "$PROFILE" ]; then usage; fi
if [ -z "$TEMPLATE" ]; then usage; fi
if [ -z "$STACK" ]; then usage; fi
if [ -z "$VERB" ]; then usage; fi

SWAGGER=$(shasum -a 256 iac/swagger.yaml | awk '{print $1}')
PARAMS="ParameterKey=ParamSwaggerBucket,ParameterValue=$S3BUCKET"
PARAMS="$PARAMS ParameterKey=ParamSwaggerKey,ParameterValue=$SWAGGER"
BASENAME=`basename $TEMPLATE .yaml`

echo
aws s3 cp iac/swagger.yaml s3://${S3BUCKET}/${SWAGGER}

if [[ $BUILD == "true" ]]; then
sam build --profile $PROFILE --build-dir build --manifest requirements.txt --template $TEMPLATE --parameter-overrides $PARAMS --use-container 
sam package --template-file build/template.yaml --output-template-file iac/${BASENAME}_output.yaml --s3-bucket $S3BUCKET
else
sam package --template-file iac/example.yaml --output-template-file iac/${BASENAME}_output.yaml --s3-bucket $S3BUCKET
fi

if [[ $VERB == "deploy" ]]; then
sam deploy --template-file iac/${BASENAME}_output.yaml --stack-name $STACK --parameter-overrides $PARAMS --capabilities CAPABILITY_NAMED_IAM
elif [[ $VERB == "local" ]]; then
sam local invoke -e etc/event.json -t build/template.yaml ExampleFunction
fi

# aws --profile $PROFILE cloudformation ${VERB}-stack \
# --stack-name $STACK \
# --template-body file://$TEMPLATE \
# --parameters $PARAMS \
# --capabilities CAPABILITY_IAM
