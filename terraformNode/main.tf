provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/home/pronit/tardis/workspaces/csa/cicd/creds/test-creds"
  profile                 = "terraform"
}

resource "aws_instance" "webserver" {
  ami                    = "ami-07d0cf3af28718ef8"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1c"
  key_name               = "admin_key"
  vpc_security_group_ids = ["${aws_security_group.web-servers.id}"]
  tags = {
    Name        = "ark-labs"
    Environment = "${var.environment}"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
}

# resource "aws_instance" "i-07364308bc4be1712" {
#     ami                         = "ami-07d0cf3af28718ef8"
#     availability_zone           = "us-east-1c"
#     ebs_optimized               = false
#     instance_type               = "t2.micro"
#     monitoring                  = false
#     key_name                    = "admin_key"
#     subnet_id                   = "subnet-6387a03f"
#     vpc_security_group_ids      = ["sg-0c2336ee4e8e9ed71"]
#     associate_public_ip_address = true
#     private_ip                  = "172.31.42.244"
#     source_dest_check           = true

#     root_block_device {
#         volume_type           = "gp2"
#         volume_size           = 8
#         delete_on_termination = true
#     }

#     tags {
#     }
# }



resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.webserver.id}"
  allocation_id = "${aws_eip.web.id}"
}


resource "aws_eip" "web" {
  vpc = true
}

resource "aws_iam_role" "s3_role" {
  name = "s3_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.s3_role.name}"
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier = "${var.environment}-cluster"
  engine = "docdb"
  master_username = "test"
  master_password = "arkenea123"
  skip_final_snapshot = true
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = "${var.environment}-csa-bucket"
  acl = "private"

  tags = {
    Name = "My bucket"
    Environment = "Dev"
  }
}



# output "db-endpoint" {
#   value = ["${aws_docdb_cluster.docdb.*.endpoint}"]
# }


output "web-endpoint" {
  value = ["${aws_instance.webserver.public_ip}"]
}

output "s3-endpoint" {
  value = ["${aws_s3_bucket.s3bucket.bucket_domain_name}"]
}

output "eip-endpoint" {
  value = ["${aws_eip.web.public_ip}"]
}


resource "aws_security_group" "web-servers" {

  # "ingress" is parsed as a block because there is no equals sign
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["114.143.234.34/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
