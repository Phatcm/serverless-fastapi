from build_response import buildResponse
from google.oauth2 import id_token
from google.auth.transport import requests

from lambda_function import User

def post_user(user: User):
    try:
        # Get the ID token from the event
        id_token_str = user.id_token

        # Specify the CLIENT_ID of the app that accesses the backend
        CLIENT_ID = '515048359790-0qeabh29ovkvv4n7r27l87kvov3i94u7.apps.googleusercontent.com'

        # Verify the ID token
        idinfo = id_token.verify_oauth2_token(id_token_str, requests.Request(), CLIENT_ID)

        # ID token is valid. Get the user's Google Account ID from the decoded token.
        userid = idinfo['sub']
        email = idinfo['email']
        name = idinfo['name']
        body = {
            "userid": userid,
            "email": email,
            "name": name
        }
        print('User Info: ', body)

        #TODO: Save the user's information to DynamoDB

        return buildResponse(200, {"Message": "User authenticated successfully"})
    except ValueError as e:
        # Invalid token
        print('Invalid token: ', e)
        return buildResponse(401, {"Message": "Invalid token"})
