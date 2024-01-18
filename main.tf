terraform {
  required_version = ">=1.0.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

module "lambda_role" {
  source = "./modules/iam_role"
    iam_role_name = "fastapi_lambda_role"
    policies_list = [
    "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess","arn:aws:iam::aws:policy/CloudWatchFullAccess",
    ]
}

module "fastapi_lambda" {
    source = "./modules/lambda"
    lambda_function_name = "fastapi-lambda"
    lambda_role_arn = module.lambda_role.iam_role_arn
    lambda_handler = "lambda_function.lambda_handler"
    lambda_runtime = "python3.9"
    output_path = "./resources/lambda_function.zip"
    source_dir = "./resources/"
    filename = "./resources/lambda_function.zip"
}

module "api_gateway" {
    source = "./modules/api_gateway"
    api_name = "fastapi-api"
    lambda_function_name = module.fastapi_lambda.lambda_function_name
    lambda_invoke_arn = module.fastapi_lambda.lambda_invoke_arn
}