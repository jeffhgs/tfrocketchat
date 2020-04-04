variable "cluster_name" {}
variable "app_instance_type" {}
variable "app_instance_count" {
    default = 1
}
variable "db_password" {}

variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "region" {}
variable "ami" {}

variable "dnsDomainName" {}
variable "dnsZoneId" {}

provider "aws" {
    region = var.region
}

/*
module "script" {
  source = "./script"
  db_password = "${var.db_password}"
  db_host = "${module.rds.dbEndpoint}"
}
*/

resource "aws_instance" "app_server" {
    //tags {
    //  Name = "${var.cluster_name}-app-${count.index}"
    //}
    ami = var.ami
    instance_type = "${var.app_instance_type}"
    associate_public_ip_address = true
    vpc_security_group_ids = [
        "${aws_security_group.app.id}"
    ]
    key_name = "${aws_key_pair.key.id}"
    count = "${var.app_instance_count}"
    availability_zone = "${var.region}a"
//    user_data = "${module.script.cloudinit-config1}"
}

resource "aws_key_pair" "key" {
    key_name = "Terraform-${var.cluster_name}"
    public_key = "${var.ssh_public_key}"
}

output "instanceIP" {
    value = "${aws_instance.app_server.*.public_dns}"
}

resource "aws_route53_record" "app" {
  zone_id = var.dnsZoneId
  name    = "${var.cluster_name}.${var.dnsDomainName}"
  type    = "CNAME"
  ttl     = "300"
  records = "${aws_instance.app_server.*.public_dns}"
}

resource "aws_security_group" "app" {
    name = "${var.cluster_name}-app-security-group"
    description = "App security group for loadtest cluster ${var.cluster_name}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "app" {
    bucket = "${var.cluster_name}.loadtestbucket"
    acl = "private"
    //tags {
    //    Name = "${var.cluster_name}"
    //}
    force_destroy = true
}

output "s3bucket" {
    value = "${aws_s3_bucket.app.id}"
}

output "s3bucketRegion" {
    value = "${aws_s3_bucket.app.region}"
}

resource "aws_iam_access_key" "s3" {
    user = "${aws_iam_user.s3.name}"
}

output "s3AccessKeyId" {
    value = "${aws_iam_access_key.s3.id}"
}

output "s3AccessKeySecret" {
    value = "${aws_iam_access_key.s3.secret}"
}

resource "aws_iam_user" "s3" {
    name = "${var.cluster_name}-s3"
}

resource "aws_iam_user_policy" "s3" {
    name = "${var.cluster_name}-s3-user-access"
    user = "${aws_iam_user.s3.name}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:AbortMultipartUpload",
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.app.id}/*"
        }
    ]
}
EOF
}

