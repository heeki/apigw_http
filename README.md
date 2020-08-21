# Example HTTP API with Swagger
Sample code for deploying an HTTP API on AWS API Gateway using SAM/CloudFormation and a swagger file.

## Execution
Set an environment variable `S3BUCKET` with the name of your S3 bucket where deployment artifacts will be placed.

```bash
./deploy.sh -p [profile] -t iac/example.yaml -s httpapi -v deploy
./describe.sh -p [profile] -s httpapi
curl -s -XGET https://[api_id].execute-api.us-east-1.amazonaws.com/[stage]/profile | jq
```
