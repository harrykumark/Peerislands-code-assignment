from flask import Flask, jsonify, request
import os
app = Flask(__name__)


@app.route('/')
def hello():
return jsonify({
"message": "hello from service-a",
"pod": os.getenv('HOSTNAME')
})


@app.route('/health')
def health():
return jsonify({"status": "ok"})


if __name__ == '__main__':
app.run(host='0.0.0.0', port=80)
