from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)  # Enable CORS so frontend can access backend

# Get MongoDB URI from env var or use default (Docker Compose service name)
app.config["MONGO_URI"] = os.environ.get("MONGO_URI", "mongodb://mongo:27017/todo_db")

mongo = PyMongo(app)
todos_collection = mongo.db.todos

@app.route("/todos", methods=["GET"])
def get_todos():
    todos = list(todos_collection.find({}, {"_id": 0, "task": 1}))
    return jsonify(todos), 200

@app.route("/todos", methods=["POST"])
def add_todo():
    data = request.get_json()
    task = data.get("task")
    if not task:
        return jsonify({"error": "Task field is required"}), 400
    todos_collection.insert_one({"task": task})
    return jsonify({"message": "Task added"}), 201

@app.route("/todos/<task>", methods=["DELETE"])
def delete_todo(task):
    result = todos_collection.delete_one({"task": task})
    if result.deleted_count == 0:
        return jsonify({"error": "Task not found"}), 404
    return jsonify({"message": "Task deleted"}), 200

if __name__ == "__main__":
    # Listen on all interfaces
    app.run(host="0.0.0.0", port=5000, debug=True)

