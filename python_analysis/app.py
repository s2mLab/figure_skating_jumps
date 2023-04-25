import csv

from analysis import analyze_session
from ice_exceptions import EmptyFileError, InvalidFormatError

from flask import Flask, request
from flask_api import status

app = Flask(__name__)

FILE_REPO: str = "files"

@app.route("/test", methods = ['GET'])
def test():
    """
    Method: GET\n
    A test route to make sure the server is up and running.

    Returns:
        A 200 if the server is running
    """
    return "Server is up."

@app.route("/analyze", methods = ['POST'])
def analyze():
    """
    Method: POST\n
    Does an analysis on the designated file. The name of the file
    is passed in the body in format JSON with the key "fileName".

    Returns:
        200 with JSON formatted Jump objects containing the result 
        of the analysis
    
    Errors:
        404 if the file isn't found or if it is empty\n
        400 if the file has the wrong format\n
        500 if there is an unexpected error
    """
    try:
        fileName: str = request.json['fileName']
        result = analyze_session(f"{FILE_REPO}/{fileName}")
        return [iter.toMap() for iter in result], status.HTTP_200_OK
    except FileNotFoundError as err:
        app.logger.exception(err)
        return "File not found.", status.HTTP_404_NOT_FOUND
    except EmptyFileError as err:
        app.logger.exception(err)
        return "File is empty.", status.HTTP_404_NOT_FOUND
    except InvalidFormatError as err:
        app.logger.exception(err)
        return "File has wrong format.", status.HTTP_400_BAD_REQUEST
    except Exception as err:
        app.logger.exception(err)
        return "", status.HTTP_500_INTERNAL_SERVER_ERROR

@app.route("/file", methods = ['PUT'])
def add_file():
    """
    Method: PUT\n
    Uploads a file to the server. Takes the contents of the file as
    a raw string in the body. It also needs the name of the file
    in the query with the key "fileName".

    Returns:
        200 on a success
    
    Errors:
        500 if there is an unexpected error
    """
    try:
        fileName = request.args.get("fileName")
        fileName = fileName.replace(' ', '_')
        if not fileName.endswith('.csv'):
            fileName = f"{fileName}.csv"
        
        data = request.get_data().decode('utf-8').split('\n')
        header_len = len(data[0].split(','))
        with open(f"{FILE_REPO}/{fileName}", "w") as write_file:
            writer = csv.writer(write_file)
            for row in data:
                values = row.split(',')
                app.logger.error(len(values))
                if len(values) != header_len: continue
                writer.writerow(values)
        return "", status.HTTP_200_OK
    except Exception as err:
        app.logger.exception(err)
        return "", status.HTTP_500_INTERNAL_SERVER_ERROR

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=80)