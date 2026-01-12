from flask import Flask, request

app = Flask(__name__)

@app.route('/message', methods=['POST'])
def message():
    data = request.json  # Get JSON data from the request
    print("Message received:", data)  # Print to the server console
    return {"status": "success", "message": "Message received"}, 200

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
    print("Server is running...")


'''
To test this backend, you can use the following curl command:
curl -X POST http://127.0.0.1:5000/message ^
  -H "Content-Type: application/json" ^
  -d "{\"text\":\"hello\"}"

''' 