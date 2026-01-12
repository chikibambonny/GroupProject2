from flask import Flask, request

app = Flask(__name__)

@app.route('/message', methods=['POST'])
def message():
    data = request.json  # Get JSON data from the request
    print("Message received:", data)  # Print to the server console
    return {"status": "success", "message": "Message received"}, 200

if __name__ == '__main__':
    app.run(debug=True)
