from flask import Flask, render_template, jsonify
import random

app = Flask(__name__)
@app.route('/')
def index():
    return render_template('index.html', message="Hello from PeerIsland Sample App!")
@app.route('/health')
def health():
    return jsonify({"status": "ok"})
@app.route('/metrics')
def metrics():
    return jsonify({"cpu": random.randint(10,90), "memory": random.randint(100,500)})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
