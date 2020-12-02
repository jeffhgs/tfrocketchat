
# Synopsis

Immutable infrastructure terraform deployment scripts for testing rocketchat.

# Scope

Things required for testing the server and phone apps are included, such as:

  - Database backend
  - SSL

Backup, monitoring and other things related to production installation are out of scope.

One master initialization script is generated for all server configuration.  For speed of troubleshooting, the script presumes access to an ssh port on the server, instead of passing the script through EC2 userdata.

Recommended use when network must be closed is to apply the script on a bastion host.

# Prerequisites

- Terraform.  Tested with version 0.13.5

# Instructions

## Configure

Choose three environment variables:

| Name | Description |
|---|---|
| AWS_PROFILE | An AWS credential provided in ~/.aws/credentials |
| AWS_DEFAULT_REGION | An AWS region, such as "us-west-2"|
| STAGE | A user-defined string, such as "prod", "dev", etc.  STAGE becomes the name of your .tfvars configuration file. |

For the purpose of this README, these environment values will be denoted in the way that shell denotes variable substitution, e.g. $STAGE.

Copy the sample configuration file:

    cp rocketchat.example_tfvars $STAGE.tfvars

Populate the configuration file with required values.  Comments in the example file describe the values.

One of the configuration file entries is cluster_name, which is a DNS entry to create.  You might consider setting cluster_name to the name of the file.

## Deploy
    env STAGE=$STAGE bash clean.sh
    env AWS_PROFILE=$AWS_PROFILE AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION STAGE=$STAGE bash make.sh

## Destroy:
    env AWS_PROFILE=$AWS_PROFILE AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION STAGE=$STAGE bash destroy.sh

# Advanced instructions

## Connect to server for troubleshooting
    userChat=ubuntu
    hostChat=$hostChat
    ssh -i $pathToSshKey -l $userChat $hostChat

## Manually regenerate server install script and apply to the running instance
    bash out/rerun.sh
