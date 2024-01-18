data "archive_file" "lambda_layer" {
  type        = "zip"
  source_dir  = "fastApi"
  output_path = "lambda_layer_payload.zip"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename            = data.archive_file.lambda_layer.output_path
  layer_name          = "fastApi"
  description         = "lambda layer for fastapi related dependencies"
  compatible_runtimes = ["python3.9"]
}

data "archive_file" "lambda_zip" {
  type = "zip"
  output_path = var.output_path
  source_dir = var.source_dir
}

resource "aws_lambda_function" "lambda_function" {
    filename = var.filename
    function_name = var.lambda_function_name
    role = var.lambda_role_arn

    handler = var.lambda_handler
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime = var.lambda_runtime

    timeout = 500

    layers = [aws_lambda_layer_version.lambda_layer.arn]
    depends_on = [ aws_lambda_layer_version.lambda_layer ]
}