# This is a script to set up the "finder" namespace in CouchDB. Run this if you are missing some of those
# This will NOT override existing "finder" namespaces!

curl -T find -H "Content-Type: application/json" localhost:5984/error/_design/finder
curl -T project -H "Content-Type: application/json" localhost:5984/project/_design/finder
curl -T user -H "Content-Type: application/json" localhost:5984/user/_design/finder
curl -T message -H "Content-Type: application/json" localhost:5984/message/_design/finder
curl -T find -H "Content-Type: application/json" localhost:5984/glossary/_design/finder
curl -T find -H "Content-Type: application/json" localhost:5984/feedback/_design/finder