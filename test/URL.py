import urllib.parse

url = "http://127.0.0.1:5000/printer/queue"
parsed_url = urllib.parse.urlparse(url)

print(parsed_url)
print("Host name: ", parsed_url.netloc)
print(parsed_url.scheme)