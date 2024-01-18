resource "aws_api_gateway_rest_api" "api_gateway" {
    name        = var.api_name
    description = "This is my API for demonstration purposes"
    endpoint_configuration {
        types = ["REGIONAL"]
    }
}


#deployment
resource "aws_api_gateway_deployment" "api_gateway" {
    
    rest_api_id = aws_api_gateway_rest_api.api_gateway.id
    stage_name = "dev"

    triggers = {
        redeployment = sha1(jsonencode([
            file("modules/api_gateway/root.tf"),
            file("modules/api_gateway/proxy.tf"),
        ]))
    }

    lifecycle {
        create_before_destroy = true
    }

    depends_on = [
        aws_api_gateway_rest_api.api_gateway,
        #root
        aws_api_gateway_integration.root_any,
        aws_api_gateway_integration.root_options,
        aws_api_gateway_method_response.root_options,
        aws_api_gateway_integration_response.root_options,
        #proxy
        aws_api_gateway_integration.proxy_any,
        aws_api_gateway_integration.proxy_options,
        aws_api_gateway_method_response.proxy_options,
        aws_api_gateway_integration_response.proxy_options,
    ]
}

# Permission
resource "aws_lambda_permission" "apigw" {
    action        = "lambda:InvokeFunction"
    function_name = var.lambda_function_name
    principal     = "apigateway.amazonaws.com"

    source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*/*"
}

