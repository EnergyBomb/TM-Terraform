#Lambda function
resource "aws_lambda_function" "file_upload" {
  function_name = "s3-upload-function"
  filename = "lambda_function.zip" #ZIP containing Lambda
  runtime = "python3.9"
  role = aws_iam_role.lambda.arn
  handler = "lambda_function.lambda_handler"

  environment {
    variables = {
      S3_BUCKET = aws_s3_bucket.tm-lode-bucket.id
    }
  }
}

# API Gateway
resource "aws_api_gateway_rest_api" "api_upload" {
  name = "FileUploadAPI"
}

#API Gateway Recource
resource "aws_api_gateway_resource" "resource_upload" {
  rest_api_id = aws_api_gateway_rest_api.api_upload.id
  parent_id   = aws_api_gateway_rest_api.api_upload.root_resource_id
  path_part   = "upload"
}

#API Gateway Method
resource "aws_api_gateway_method" "method_upload" {
  rest_api_id   = aws_api_gateway_rest_api.api_upload.id
  resource_id   = aws_api_gateway_resource.resource_upload.id
  http_method   = "POST"
  authorization = "NONE"
}

#API gateway Integration
resource "aws_api_gateway_integration" "integration_upload" {
  rest_api_id             = aws_api_gateway_rest_api.api_upload.id
  resource_id             = aws_api_gateway_resource.resource_upload.id
  http_method             = aws_api_gateway_method.method_upload.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.file_upload.invoke_arn
}

#Lambda Permission for API
resource "aws_lambda_permission" "api_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_upload.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_upload.execution_arn}/*/*"
}

#API Deployment
resource "aws_api_gateway_deployment" "upload_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_upload.id
  depends_on  = [aws_api_gateway_integration.integration_upload]
}

#API Gateway
resource "aws_api_gateway_stage" "name" {
  deployment_id = aws_api_gateway_deployment.upload_deployment.id
  stage_name  = "work"
  rest_api_id = aws_api_gateway_rest_api.api_upload.id
}

# Output the API endpoint URL
output "api_endpoint" {
  value = "https://${aws_api_gateway_rest_api.api_upload.id}.execute-api.${var.region}.amazonaws.com/work/upload"
}