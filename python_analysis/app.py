from analysis import analyze_session
from os.path import exists

from flask import Flask, request, jsonify
from flask_api import status
# from app import app

app = Flask(__name__)

FILE_REPO: str = "files"

@app.route("/test", methods = ['GET'])
def test():
    return "Server is up."

@app.route("/analyze", methods = ['POST'])
def analyze():
    try:
        fileName: str = request.json['fileName']
        return jsonify(analyze_session(f"{FILE_REPO}/{fileName}"))
    except FileNotFoundError as err:
        return "", status.HTTP_404_NOT_FOUND
    except Exception as err:
        return "", status.HTTP_400_BAD_REQUEST

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=80)