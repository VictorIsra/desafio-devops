from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/")
def blank():
    return "Hello world!"

@app.route("/healthcheck")
def healthcheck():
    response = {
        "message": "OK"
    }
    return jsonify(response), 200
