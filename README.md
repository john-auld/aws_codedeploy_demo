# CodeDeploy

This demo project shows a simple example of using AWS CodeDeploy with a EC2 instance. The goal of the demo is to show how to setup CodeDeploy using the AWS cli to deploy onto an On-Prem or EC2 instance.

A sample IAM policy is included for the service role: code_deploy_policy.json.

The deployment creates a python virtual environment on a CentOS 7 instance (install_dependencies.sh) and copies test.txt to /tmp. You can use this demo as template for your application.


## AWS CLI Commands for setting up CodeDeploy

Create a application for use with EC2 instances on AWS.

```
aws deploy create-application --application-name CodeDeployTestJAuld --compute-platform Server --profile dev --region eu-west-2
{
    "applicationId": "92d5c4ad-1ecd-4183-8ea8-ed97e7884540"
}
```

Optional. Create a deployment configuration, which can be used to direct CodeDeploy on how to perform the deployment. For example, on one instance at a time or all at once.

This step can be skiiped if one of the standard AWS deployment configurations is suitable, e.g. CodeDeployDefault.AllAtOnce.

```
aws deploy create-deployment-config --deployment-config-name DC_CodeDeployTestJAuld --compute-platform Server --minimum-healthy-hosts type=HOST_COUNT,value=1 --profile dev --region eu-west-2
{
    "deploymentConfigId": "9ec89e84-8a3f-40ee-a48d-8000dcbf976d"
}
```

Create a Deployment Group to target the instances on which the deployment will run and the IAM service role to use.

```
aws deploy create-deployment-group --application-name CodeDeployTestJAuld --deployment-group-name DG_CodeDeployTestJAuld --ec2-tag-filters Key=Name,Value=unique-name-1,Type=KEY_AND_VALUE --service-role-arn arn:aws:iam::123451234512:role/CodeDeployTest --profile dev --region eu-west-2
{
    "deploymentGroupId": "dc320a41-88e7-42b7-a08e-e91931a556f5"
}
```

## Deploy the application

Create a zip file containing the application files and upload that to a S3 bucket.

```
aws deploy push --application-name CodeDeployTestJAuld --source app --s3-location s3://codedeploy-test-jauld/CodeDeployTestJAuld.zip --profile dev --region eu-west-2
```

To deploy with this revision, run:

```
aws deploy create-deployment --application-name CodeDeployTestJAuld --s3-location bucket=codedeploy-test-jauld,key=CodeDeployTestJAuld.zip,bundleType=zip,eTag=f389b3cea102138f5f2c7751beb0fdac --deployment-group-name DG_CodeDeployTestJAuld --deployment-config-name CodeDeployDefault.AllAtOnce --description "CodeDeploy test by JAuld"
```