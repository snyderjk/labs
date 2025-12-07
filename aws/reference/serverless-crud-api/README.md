# Serverless CRUD API

REST API using Lambda, API Gateway, and DynamoDB.

## Architecture

### Components

- API Gateway (HTTP API) - RESTful endpoint routing with automatic stage deployment
- AWS Lambda (Python 3.12) - Serverless compute for application logic
- DynamoDB - NoSQL database

### How it Works

API Gateway routes requests to Lambda functions that validate input read/write to DynamoDB, and return JSON responses.

### Data Model

** Item **
- `id` (String, Partition Key) - UUID v4
- `name` (String, Required) - Item name
- `description` (String, Optional) - Item description
- `status` (String, Optional) - active/inactive
- `metadata` (Object, Optional) - Flexible key-value pairs
- `created_at` (String) - ISO 8601 timestamp
- `updated_at` (String) - ISO 8601 timestamp

### API Endpoints

| Method | Endpoint | Lambda Function | Description |
|--------|----------|----------------|-------------|
| POST | `/items` | create_item | Create a new item |
| GET | `/items` | list_items | List all items |
| GET | `/items/{id}` | read_item | Get a specific item |
| PUT | `/items/{id}` | update_item | Replace entire item (requires all fields) |
| PATCH | `/items/{id}` | patch_item | Partial update (only provided fields) |
| DELETE | `/items/{id}` | delete_item | Delete an item |



## Usage

### Prerequisites

- Terraform >= v1.14
- AWS CLI v2 configured with appropriate credentials
- S3 backend for Terraform state (bucket + DynamoDB table with LockID key)

### Deploy the Infrastructure

1. **Clone the repository** to your local system

2. **Configure backend** (if using remote state):
   - Update `backend.tf` with your S3 bucket name and DynamoDB table name

3. **Review variables** in `variables.tf`:
   - `project_name` - Name for your project (used with AWS Account ID for unique S3 bucket name)
   - `environment` - Environment tag (default: `dev`)

4. **Set required variables** in `terraform.tfvars`:
```hcl
   project_name = "your-project-name"
```
   You can override any other variables here as needed.

### Deployment

```bash
# Initialize Terraform (downloads providers, configures backend)
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply

# Clean up
terraform destroy
```

## Usage Examples

Replace `{API_URL}` with your API Gateway endpoint from terraform output.

## Design Decisions

### Why Separate Lambda Functions?

Rather than a single monolithic Lambda:

- Single Responsibility Principle - Each function does one thing well
- Independent Scaling - AWS scales each function independently based on traffic
- Easier Testing - Smaller, focused functions are easier to test and debug
- Granular Permissions - Could implement least-privilege per function (currently shared for simplicity)
- Clearer Logs - Separate CloudWatch log groups per function

### IAM Design: Shared vs Per-Function Roles

Currently using a **shared IAM role** across all Lambda functions with full CRUD permissions on the DynamoDB table.

**Why shared:**
- All functions access the same table
- Simpler Terraform (fewer resources)
- Security boundary is already clear (scoped to one table)
- Easier to understand for code review

**Production alternative:**
- Separate roles per function (read_item only gets GetItem permission)
- More secure but significantly more complex
- Better for multi-team environments

## Implementation Notes

DynamoDB UpdateExpression: Building dynamic update expressions with ExpressionAttributeNames/Values was unintuitive. Spent time debugging expression syntax before the partial update logic worked.

Lambda code duplication: Each function repeats validation and response formatting. In production, I'd extract this to a shared layer or utility module, but wanted to keep each function self-contained for this demo.

HTTP API choice: Went with HTTP API (v2) instead of REST API (v1) - simpler config, 70% cheaper, and sufficient for this use case.

## Future Enhancements
- Pagination - Implement DynamoDB pagination for large result sets in LIST operation
- Input Validation - Add JSON Schema validation in Lambda functions
- API Documentation - OpenAPI/Swagger specification

## Author

Jason Snyder - [GitHub](https://github.com/snyderjk) | [LinkedIn](https://linkedin.com/in/jason-devops)

Part of an AWS Infrastructure as Code Reference Project Repository
