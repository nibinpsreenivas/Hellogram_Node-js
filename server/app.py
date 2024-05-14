import json
from PIL import Image
from keras.models import load_model
from flask import Flask, request, jsonify
import face_recognition
import base64
from keras.preprocessing.image import img_to_array
import mysql.connector
import numpy as np
import cv2
import numpy as np
app = Flask(__name__)

# Connect to MySQL database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="Sa2805#*",
    database="face"
)
cursor = db.cursor()
def base64_to_array(encoded_string):
    decoded_bytes = base64.b64decode(encoded_string)
    nparr = np.frombuffer(decoded_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    return img
# Helper function to convert base64 encoded image to numpy array
    
@app.route('/register', methods=['POST'])
def register_user():
    data = request.json
    username = data['username']
    photo_base64 = data['photo']
    print("REG HELLLLOOOOOOOOOOOOOOOOO")
    # Convert base64 encoded image to numpy array
    photo = base64_to_array(photo_base64)
    
    # Extract face encoding
    encoding = face_recognition.face_encodings(photo)[0]
    
    # Store username and face encoding in MySQL database
    sql = "INSERT INTO users (username, encoding) VALUES (%s, %s)"
    val = (username, json.dumps(encoding.tolist()))
    cursor.execute(sql, val)
    db.commit()
    
    return jsonify({"message": "User registered successfully"})

# Endpoint for comparing facial images
@app.route('/compare', methods=['POST'])
def compare_faces():
    print("helloooooo")
    data = request.json
    new_photo_base64 = data['photo']
    
    # Convert base64 encoded image to numpy array
    new_photo = base64_to_array(new_photo_base64)
    
    # Extract face encoding
    new_encoding = face_recognition.face_encodings(new_photo)[0]
    
    # Retrieve registered encodings from MySQL database
    cursor.execute("SELECT * FROM users")
    rows = cursor.fetchall()
    
    # Compare new encoding with registered encodings
    for row in rows:
        encoding = np.array(json.loads(row[2]))
        match = face_recognition.compare_faces([encoding], new_encoding)
        if match[0]:
            return jsonify({"message": "Match found", "username": row[1]})

    return jsonify({"message": "No match found"})

if __name__ == '__main__':
    app.run(debug=True)
