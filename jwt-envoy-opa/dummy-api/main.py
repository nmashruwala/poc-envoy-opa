import os
from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def main():
    return {"message": "Hello World"}

@app.get("/common")
def common():
    return {"message": "common"}

@app.get("/workspaces/{id}")
def namespace(id):
    return {"message": f"You have access to workspace {id}"}

@app.get('/health')
def health():
    return 'health'
