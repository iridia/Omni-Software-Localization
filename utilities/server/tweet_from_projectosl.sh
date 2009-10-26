#!/bin/bash
curl -u projectosl:"$2" -d status="$1" http://twitter.com/statuses/update.xml

exit 0
