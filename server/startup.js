// Requires "couch.js"

if(typeof CouchDB == 'function') 
{
	var feedbackDatabase = CouchDB("UserFeedback");
	feedbackDatabase.createDb();
	
	var oslDatabase = CouchDB("OSL");
	feedbackDatabase.createDb();
}
else
{
	print("CouchDB is not defined! Normally, this means you forgot to import couch.js first.")
}