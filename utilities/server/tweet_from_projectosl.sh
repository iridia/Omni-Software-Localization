#!/bin/bash
curl -u projectosl:"$1" -d status="$2" http://twitter.com/statuses/update.xml

exit 0
