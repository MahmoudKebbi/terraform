Collecting workspace information# Equilux Energy Platform

## Overview
Equilux Energy is a comprehensive platform for energy trading and management. This repository contains the infrastructure as code (IaC) implementation using Terraform for AWS cloud deployment.

## Architecture

The platform is built on AWS using a serverless architecture with the following components:

- **Authentication & Authorization**: AWS Cognito with Google OAuth integration
- **API Layer**: RESTful APIs via API Gateway
- **Load Balancing**: AWS ALB
- **Business Logic**: AWS Lambda functions, AWS EC2, AWS Elastic BeanStalk
- **Data Storage**: DynamoDB tables
- **Real-time Communication**: WebSockets for live data exchange

## Modules

### User Management
Handles user registration, authentication, and profile management:
- User registration and authentication (with Google OAuth)
- User profile management (create, read, update, delete)
- Role-based access control (admin and regular users)
- Admin user management capabilities

### Energy Trade
Facilitates energy trading between users:
- Trade creation and management
- Real-time updates via WebSockets
- Price and availability tracking
- Admin trade oversight

### IoT
Manages IoT device integration:
- Device registration and management
- Data collection from energy devices
- Real-time monitoring
- Real-time energy trade control

### ML
Provides machine learning capabilities:
- Energy usage predictions
- Pricing optimization
- Consumption pattern analysis

### Chat
Enables communication between users:
- Real-time messaging
- Trade negotiation
- Support functionality

## Setup

### Prerequisites
- AWS Account
- Terraform (v1.0+)
- AWS CLI configured with appropriate permissions

### Configuration

1. Clone the repository:
```sh
git clone <repository-url>
cd Equilux_Energy/terraform
```

2. Create a terraform.tfvars file with the required variables:
```hcl
google_client_id     = "your-google-client-id"
google_client_secret = "your-google-client-secret"
callback_urls        = ["https://your-app-url/callback"]
region               = "eu-west-1"
user_management_tags = {
  Environment = "dev"
  Module      = "User Management"
}
energy_trade_tags = {
  Environment = "dev"
  Module      = "Energy Trade"
}
```

## Deployment

### Initialize Terraform
```sh
terraform init
```

### Plan Deployment
```sh
terraform plan
```

### Apply Infrastructure
```sh
terraform apply
```

### Module-Specific Operations
To work with specific modules:

```sh
# Deploy only user management
terraform apply -target=module.user_managment

# Destroy only energy trade module
terraform destroy -target=module.energy_trade
```

## Testing

The platform includes a complete testing framework:
- Unit tests for Lambda functions
- Integration tests for API endpoints
- End-to-end tests for user flows

## Contributing

1. Branch from main
2. Make your changes
3. Submit a pull request with a clear description of the changes

## License

This project is licensed under the [Appropriate License] - see the LICENSE file for details.