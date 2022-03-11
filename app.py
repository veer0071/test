import json
import os

import requests as requests
from flask import Flask, render_template
from requests.adapters import HTTPAdapter
from urllib3 import Retry

app = Flask(__name__)


@app.route('/')
def hello_synaos():  # hello_world page
    WELCOME_VAR = os.getenv('WELCOME_VAR', 'USER')
    return render_template('index.html', record={'heading': 'Welcome', 'content': f'Hello {WELCOME_VAR}'})


@app.route('/backend')
def api_content():  # api_content page
    api_data = None
    api_url = os.getenv('BACKEND_API_URL', 'http://localhost')
    try:
       session = requests.Session()
       retry = Retry(connect=10, backoff_factor=2)
       adapter = HTTPAdapter(max_retries=retry)
       session.mount('http://', adapter)
       response = session.get(os.getenv('BACKEND_SVC_URL', 'http://localhost'))
       api_data = response.text
    except Exception as e:
       print(e)
    return render_template('api_content.html', record={'heading': 'API Content', 'content': api_data,
                                                       'api_url': api_url})


if __name__ == '__main__':
    app.run(host='0.0.0.0')
