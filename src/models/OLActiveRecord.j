@implementation OLActiveRecord : CPObject
{
	CPString _OId @accessors(readonly, property=OId);
}

+ (OLActiveRecord)findByOId:(CPString)anOId
{
	var record = [self initWithOId:anOId];
	[record get];
	return record;
}

+ (OLActiveRecord)create
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:"api/" + urlName(self)];
	[urlRequest setHTTPMethod:"PUT"];
	
	var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	var response = eval('(' + JSONresponse + ')');
	
	return [[self alloc] initWithOId:response["_id"]];
}

- (id)init
{
	return [self initWithOId:nil];
}

- (id)initWithOId:(CPString)anOId
{
	if(self = [super init])
	{
		_OId = anOId;
	}
	return self;
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
	// some archiving stuff
	var archivedData; // IN JSON
	
	var urlRequest = [[CPURLRequest alloc] initWithURL:"api/" + urlName(self) + "/" + _OId];
	[urlRequest setHTTPMethod:"POST"];
	[urlRequest setHTTPBody:archivedData];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
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
