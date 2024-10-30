provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  
  s3_use_path_style = true
  
  endpoints {
    apigateway     = var.aws_endpoint
    cloudformation = var.aws_endpoint
    cloudwatch     = var.aws_endpoint
    dynamodb       = var.aws_endpoint
    ec2            = var.aws_endpoint
    es             = var.aws_endpoint
    elasticache    = var.aws_endpoint
    firehose       = var.aws_endpoint
    iam            = var.aws_endpoint
    kinesis       = var.aws_endpoint
    lambda         = var.aws_endpoint
    rds           = var.aws_endpoint
    redshift      = var.aws_endpoint
    route53       = var.aws_endpoint
    s3            = var.aws_endpoint
    secretsmanager = var.aws_endpoint
    ses           = var.aws_endpoint
    sns           = var.aws_endpoint
    sqs           = var.aws_endpoint
    ssm           = var.aws_endpoint
    stepfunctions = var.aws_endpoint
    sts           = var.aws_endpoint
  }
}

# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source_dir = "${path.module}/lambda"
}

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create Lambda function
resource "aws_lambda_function" "test_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "test_lambda"
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = "nodejs18.x"
}

# Output the Lambda function ARN
output "lambda_arn" {
  value = aws_lambda_function.test_lambda.arn
}