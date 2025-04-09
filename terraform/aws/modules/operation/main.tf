resource "aws_security_group" "instance" {
  name_prefix = "${var.prefix}-operation-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-operation-sg"
    }
  )
}

resource "aws_iam_role" "ssm_role" {
  name = "${var.prefix}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "secretsmanager_access" {
  name        = "${var.prefix}-secretsmanager-access"
  description = "Policy to allow access to specific Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Effect   = "Allow"
        Resource = var.db_secret_arn
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_patch_association" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
}

resource "aws_iam_role_policy_attachment" "secretsmanager_access" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.secretsmanager_access.arn
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.prefix}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "operation" {
  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-ssm-agent
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              
              yum install -y mariadb
              
              yum install -y golang
              
              yum install -y jq
              
              echo 'export GOPATH=/home/ec2-user/go' >> /home/ec2-user/.bashrc
              echo 'export PATH=$PATH:/home/ec2-user/go/bin' >> /home/ec2-user/.bashrc
              mkdir -p /home/ec2-user/go/{bin,pkg,src}
              chown -R ec2-user:ec2-user /home/ec2-user/go
              
              mkdir -p /home/ssm-user/.aws
              
              cat > /home/ssm-user/.aws/config << 'AWSCONFIG'
              [default]
              region = ap-northeast-1
              AWSCONFIG
              
              # 権限を設定
              chown -R ssm-user:ssm-user /home/ssm-user/.aws
              chmod 700 /home/ssm-user/.aws
              chmod 600 /home/ssm-user/.aws/config
              EOF

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-operation-instance"
    }
  )
}
