@import <Foundation/CPObject.j>

@implementation OLActiveRecord : CPObject
{
	CPString _OId @accessors(property=OId);
}

+ (OLActiveRecord)findByOId:(CPString)anOId
{
	var record = [self init];
	[record setOId:anOId];
	[record get];
	return record;
}

- (id)get
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:"api/" + urlName(self) + "/" + _OId];
	[urlRequest setHTTPMethod:"GET"];
	
	var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	var response = eval('(' + JSONresponse + ')');
	
	// some unarchiving stuff
}

- (id)save
{
	if(!_OId)
	{
		var urlRequest = [[CPURLRequest alloc] initWithURL:"api/" + urlName(self)];
		[urlRequest setHTTPMethod:"PUT"];
	
		// some archiving stuff
		var archivedData; // IN JSON
		
		[urlRequest setHTTPBody:archivedData];
		
		var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
		
		var response = eval('(' + JSONresponse + ')');
		
		_OId = response["_id"];	
	}
	else
	{
		// some archiving stuff
		var archivedData; // IN JSON
		
		var urlRequest = [[CPURLRequest alloc] initWithURL:"api/" + urlName(self) + "/" + _OId];
		[urlRequest setHTTPMethod:"POST"];
		[urlRequest setHTTPBody:archivedData];
		
		[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
	}
}

- (id)delete
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:"api/" + urlName(self) + "/" + _OId];
	[urlRequest setHTTPMethod:"DELETE"];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
}

@end

function urlName(self)
{
	return class_getName([self class]).replace("OL","").toLowerCase();
}
