#!/usr/bin/env python

import sys
import yaml
import json

try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper

def date_handler(obj):
    return obj.isoformat() if hasattr(obj, 'isoformat') else obj

 
data = json.load(sys.stdin)
#yaml = yaml.dumps(data, default=date_handler, indent=4, separators=(',', ': '))
#yaml = yaml.dump(data, allow_unicode=True, Dumper=Dumper)
yaml = yaml.safe_dump(data)
 
print(yaml)
