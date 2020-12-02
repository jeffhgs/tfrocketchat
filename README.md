
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

## Successful deployment

    . . .
    about to apply
    local_file.conf-json: Creating...
    local_file.conf-json: Creation complete after 0s [id=b1c7dc5ac14bfdef07e90c80c2adbc41225822f5]
    aws_s3_bucket.app: Creating...
    aws_iam_user.s3: Creating...
    aws_key_pair.key: Creating...
    aws_security_group.app: Creating...
    aws_key_pair.key: Creation complete after 1s [id=Terraform-rocketchata]
    aws_iam_user.s3: Creation complete after 1s [id=rocketchata-s3]
    aws_iam_access_key.s3: Creating...
    aws_iam_access_key.s3: Creation complete after 0s [id=AKIAU2UUF2CIMIVCJCMI]
    aws_security_group.app: Creation complete after 2s [id=sg-0534d1d70d9ddbc43]
    aws_instance.app_server[0]: Creating...
    aws_s3_bucket.app: Creation complete after 3s [id=rocketchata.loadtestbucket]
    aws_iam_user_policy.s3: Creating...
    aws_iam_user_policy.s3: Creation complete after 0s [id=rocketchata-s3:rocketchata-s3-user-access]
    aws_instance.app_server[0]: Still creating... [10s elapsed]
    aws_instance.app_server[0]: Still creating... [20s elapsed]
    aws_instance.app_server[0]: Still creating... [30s elapsed]
    aws_instance.app_server[0]: Creation complete after 33s [id=i-01b1d6f77df1bf74a]
    data.template_file.rerun-sh: Reading...
    aws_route53_record.app: Creating...
    data.template_file.rerun-sh: Read complete after 0s [id=24a73d104c08d935891f960c86235f06961ebb6544d07b19a1003f835f06f0cf]
    local_file.reprovision: Creating...
    local_file.reprovision: Creation complete after 0s [id=1f82c0d6a3695061d4b400863962941afe74661f]
    aws_route53_record.app: Still creating... [10s elapsed]
    aws_route53_record.app: Still creating... [20s elapsed]
    aws_route53_record.app: Still creating... [30s elapsed]
    aws_route53_record.app: Creation complete after 33s [id=Z1ZA0WVFCZ9T28_rocketchata.groovescale.com_CNAME]

    Warning: Interpolation-only expressions are deprecated

      on cluster.tf line 35, in resource "aws_instance" "app_server":
      35:     instance_type = "${var.app_instance_type}"

    Terraform 0.11 and earlier required all non-constant expressions to be
    provided via interpolation syntax, but this pattern is now deprecated. To
    silence this warning, remove the "${ sequence from the start and the }"
    sequence from the end of this expression, leaving just the inner expression.

    Template interpolation syntax is still used to construct strings from
    expressions when the template includes multiple interpolation sequences or a
    mixture of literal strings and interpolations. This deprecation applies only
    to templates that consist entirely of a single interpolation sequence.

    (and 17 more similar warnings elsewhere)


    Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

    The state of your infrastructure has been saved to the path
    below. This state is required to modify and destroy your
    infrastructure, so keep it safe. To inspect the complete state
    use the `terraform show` command.

    State path: terraform.tfstate

    Outputs:

    instanceIP = [
      "ec2-52-36-169-253.us-west-2.compute.amazonaws.com",
    ]
    . . .

## Successful destroy

Destrying will prompt for confirmation:

    Do you really want to destroy all resources?
      Terraform will destroy all your managed infrastructure, as shown above.
      There is no undo. Only 'yes' will be accepted to confirm.

      Enter a value:

Upon confirmation, you will see:

      Enter a value: yes

    local_file.conf-json: Destroying... [id=b1c7dc5ac14bfdef07e90c80c2adbc41225822f5]
    local_file.reprovision: Destroying... [id=1f82c0d6a3695061d4b400863962941afe74661f]
    local_file.conf-json: Destruction complete after 0s
    local_file.reprovision: Destruction complete after 0s
    aws_iam_user_policy.s3: Destroying... [id=rocketchata-s3:rocketchata-s3-user-access]
    aws_iam_access_key.s3: Destroying... [id=AKIAU2UUF2CIMIVCJCMI]
    aws_route53_record.app: Destroying... [id=Z1ZA0WVFCZ9T28_rocketchata.groovescale.com_CNAME]
    aws_iam_access_key.s3: Destruction complete after 0s
    aws_iam_user_policy.s3: Destruction complete after 0s
    aws_iam_user.s3: Destroying... [id=rocketchata-s3]
    aws_s3_bucket.app: Destroying... [id=rocketchata.loadtestbucket]
    aws_s3_bucket.app: Destruction complete after 0s
    aws_iam_user.s3: Destruction complete after 1s
    aws_route53_record.app: Still destroying... [id=Z1ZA0WVFCZ9T28_rocketchata.groovescale.com_CNAME, 10s elapsed]
    aws_route53_record.app: Still destroying... [id=Z1ZA0WVFCZ9T28_rocketchata.groovescale.com_CNAME, 20s elapsed]
    aws_route53_record.app: Still destroying... [id=Z1ZA0WVFCZ9T28_rocketchata.groovescale.com_CNAME, 30s elapsed]
    aws_route53_record.app: Destruction complete after 32s
    aws_instance.app_server[0]: Destroying... [id=i-01b1d6f77df1bf74a]
    aws_instance.app_server[0]: Still destroying... [id=i-01b1d6f77df1bf74a, 10s elapsed]
    aws_instance.app_server[0]: Still destroying... [id=i-01b1d6f77df1bf74a, 20s elapsed]
    aws_instance.app_server[0]: Destruction complete after 30s
    aws_key_pair.key: Destroying... [id=Terraform-rocketchata]
    aws_security_group.app: Destroying... [id=sg-0534d1d70d9ddbc43]
    aws_key_pair.key: Destruction complete after 1s
    aws_security_group.app: Destruction complete after 1s

    Destroy complete! Resources: 10 destroyed.

  
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
