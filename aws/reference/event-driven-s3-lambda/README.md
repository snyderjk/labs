# Event-Driven S3 to Lambda Pipeline

## Overview

This project demonstrates an event-driven serverless architecture on AWS using Terraform. When a file is uploaded to an S3 bucket, an event notification automatically triggers a Lambda function that processes the file and logs details to CloudWatch. This pattern is commonly used for real-time data processing, file validation, image transformation, and ETL workflows.

**Key Technologies:**
- **Terraform** - Infrastructure as Code for AWS resource provisioning
- **AWS S3** - Object storage with event notifications
- **AWS Lambda** - Serverless compute for event processing
- **AWS CloudWatch** - Centralized logging and monitoring
- **AWS IAM** - Security and access management

**What This Demonstrates:**
- Event-driven architecture patterns
- Serverless computing with Lambda
- Infrastructure as Code best practices
- AWS service integration
- Security configurations (IAM roles, S3 bucket policies)
- Operational excellence (CloudWatch logging, log retention)

## Architecture

### Architecture Diagram
```
┌─────────────┐         ┌──────────────────┐         ┌─────────────────┐
│             │         │                  │         │                 │
│  S3 Bucket  │────────▶│ Lambda Function  │────────▶│ CloudWatch Logs │
│             │ Event   │                  │ Writes  │                 │
└─────────────┘         └──────────────────┘         └─────────────────┘
      │                          │
      │                          │
      ▼                          ▼
 Versioning               IAM Execution Role
 Encryption               (Least Privilege)
 Private Access
```

### Component Details

**S3 Bucket:**
- Private bucket with all public access blocked
- Versioning enabled for object protection
- Server-side encryption (SSE-S3) by default
- Event notification configured for `s3:ObjectCreated:*` events

**Lambda Function:**
- Python 3.12 runtime
- Triggered automatically by S3 events
- Extracts file metadata (bucket name, object key, event type)
- Logs processing details to CloudWatch

**IAM Role:**
- Least privilege access with managed policy
- Trust relationship allowing Lambda service assumption
- CloudWatch Logs write permissions via `AWSLambdaBasicExecutionRole`

**CloudWatch Logs:**
- Dedicated log group: `/aws/lambda/{function-name}`
- 30-day retention policy
- Captures all Lambda execution logs and errors

### Event Flow

1. User uploads file to S3 bucket
2. S3 triggers event notification
3. Lambda function receives event payload containing:
   - Bucket name
   - Object key (filename)
   - Event type
   - Event timestamp
4. Lambda processes event and logs details
5. CloudWatch captures logs for monitoring and debugging

## Prerequisites

**Required:**
- AWS Account with appropriate permissions (S3, Lambda, IAM, CloudWatch)
- AWS CLI configured with credentials
- Terraform >= 1.0
- S3 backend for Terraform state (already configured)

**AWS Permissions Needed:**
- `s3:*` - Create and configure S3 buckets
- `lambda:*` - Create and manage Lambda functions
- `iam:*` - Create IAM roles and attach policies
- `logs:*` - Create CloudWatch log groups

**Terraform Backend:**
This project uses a remote S3 backend with state locking:
- State bucket: `snyderjk-terraform-state-files`
- State key: `projects/event-driven-s3-lambda/terraform.tfstate`
- Lock table: `terraform-statefile-locks`
- Region: `us-east-1`
