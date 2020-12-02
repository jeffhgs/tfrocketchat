
# Synopsis

Immutable infrastructure terraform deployment scripts for testing [rocketchat](https://rocket.chat/), a real time messaging system for teams.

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

Copy the sample configuration file:

    cp rocketchat.example_tfvars $STAGE.tfvars

Populate the configuration file with required values.  Comments in the example file describe the values.

One of the configuration file entries is cluster_name, which is a DNS entry to create.  You might consider setting cluster_name to the name of the file.

## Convention for writing commands

For the purpose of this README, these environment values will be denoted in the way that shell denotes variable substitution, e.g. $STAGE.

Using our convention for environment variables carries the convenience that if we set each of our three environment variables like so:

    export STAGE=beta

then we can use the commands in the instructions verbatim:

    env STAGE=$STAGE bash clean.sh

And the shell will substitute our values.

## Deploy

There are only two commands for deployment.  To deploy:

    env AWS_PROFILE=$AWS_PROFILE AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION STAGE=$STAGE bash make.sh

## Destroy

To destroy the deployment:

    env AWS_PROFILE=$AWS_PROFILE AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION STAGE=$STAGE bash destroy.sh

That's all.

  
# Advanced instructions

## Deep clean

If making big changes to the manifest, it may be necessary to destroy all terrafrom intermediate results:

    env STAGE=$STAGE bash clean.sh

## Connect to server for troubleshooting
    userChat=ubuntu
    hostChat=$hostChat
    ssh -i $pathToSshKey -l $userChat $hostChat

## Manually regenerate server install script and apply to the running instance
    bash out/rerun.sh
