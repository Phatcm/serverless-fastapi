from fastapi import FastAPI
from mangum import Mangum
import json
from pydantic import BaseModel

from def_user import post_user


app = FastAPI()
lambda_handler = Mangum(app)

class User(BaseModel):
    id_token: str

@app.post("/user")
def post_user_handler(user: User):
    return post_user(user)

