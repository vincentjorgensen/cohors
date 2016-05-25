#!/usr/bin/env python

import sys
import yaml
import json

def date_handler(obj):
    return obj.isoformat() if hasattr(obj, 'isoformat') else obj

 
data = yaml.load(sys.stdin)
json = json.dumps(data, default=date_handler, indent=4, separators=(',', ': '))
 
print(json)
