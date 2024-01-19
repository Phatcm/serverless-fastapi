from fastapi import Response
from custom_encoder import CustomEncoder
import json

def buildResponse(statusCode, body=None):
    headers = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*", 
        "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token",
    }

    if body is not None:
        body = json.dumps(body, cls=CustomEncoder)
    return Response(content=body, status_code=statusCode, headers=headers)
