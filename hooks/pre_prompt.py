#!/usr/bin/env python
import json
import uuid
from datetime import datetime

template = 'cookiecutter.json'

with open(template, 'r') as file:
    data = json.load(file)

data['uuid'] = str(uuid.uuid4())
data['year'] = str(datetime.now().year)


with open(template, 'w') as file:
    json.dump(data, file, indent=2)
