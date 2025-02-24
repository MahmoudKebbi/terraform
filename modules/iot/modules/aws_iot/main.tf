resource "aws_iot_thing_type" "gateway_type" {
  name = "GatewayDevice"
}
resource "aws_iam_role" "iot_provisioning_role" {
  name = "IoTProvisioningRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "iot.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "iot_provisioning_policy" {
  name = "IoTProvisioningPolicy"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "iot:CreateThing",
        "iot:AttachPolicy",
        "iot:UpdateCertificate",
        "iot:CreateKeysAndCertificate",
        "iot:DescribeThing",
        "iot:ListThings",
        "iot:CreateThingGroup",
        "iot:AddThingToThingGroup"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "iot_provisioning_attach" {
  role       = aws_iam_role.iot_provisioning_role.name
  policy_arn = aws_iam_policy.iot_provisioning_policy.arn
}
resource "aws_iot_provisioning_template" "jitp_template" {
  name                  = "GatewayProvisioningTemplate"
  provisioning_role_arn = aws_iam_role.iot_provisioning_role.arn
  enabled               = true

  template_body = <<EOF
{
  "Parameters": {
    "ThingName": {
      "Type": "String"
    }
  },
  "Resources": {
    "thing": {
      "Type": "AWS::IoT::Thing",
      "Properties": {
        "ThingName": {"Ref": "ThingName"},
        "ThingTypeName": "GatewayDevice"
      }
    },
    "certificate": {
      "Type": "AWS::IoT::Certificate",
      "Properties": {
        "Status": "ACTIVE"
      }
    },
    "policy": {
      "Type": "AWS::IoT::Policy",
      "Properties": {
        "PolicyName": "GatewayDevicePolicy"
      }
    }
  }
}
EOF
}
resource "aws_iot_policy" "device_policy" {
  name = "GatewayDevicePolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iot:Connect",
        "iot:Publish",
        "iot:Subscribe",
        "iot:Receive"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
