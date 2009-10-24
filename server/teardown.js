// Requires "couch.js"

if(typeof CouchDB == 'function') 
{
	var feedbackDatabase = CouchDB("UserFeedback");
	feedbackDatabase.deleteDb();
	
	var oslDatabase = CouchDB("OSL");
	feedbackDatabase.deleteDb();
}
else
{
	print("CouchDB is not defined! Normally, this means you forgot to import couch.js first.")
}