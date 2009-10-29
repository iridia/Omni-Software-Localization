@import <AppKit/CPObject.j>

@implementation OLActiceRecord : CPObject
{
	CPString _url @accessors(property=url, readonly);
	CPString _OId @accessors(property=OId, readonly);
}

+ (id)get:(JSObject)idToGet
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self url] + "/" + idToGet];
	[urlRequest setHTTPMethod:@"GET"];
	
	var newObject = [[self alloc] init];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:newObject startImmediately:YES];
	
	return newObject;
}

+ (id)create
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self url]];
	[urlRequest setHTTPMethod:@"POST"];
	
	var newObject = [[self alloc] init];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:newObject startImmediately:YES];
	
	return newObject;
}

- (id)init
{
	[self initWithOId:nil];
}

- (id)initWithOId:(CPString)anOid
{
	if(self = [super init])
	{
		_url = @"api/" + [self isa].name.replace("OL","").toLowerCase();
		_OId = newOid;
	}
	return self;
}

- (void)save
{
	var jsonData = [[self encode:[[OLKeyedArchiver alloc] init]] data];
	
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self url] + "/" + [self id]];
	[urlRequest setHTTPMethod:@"PUT"];
	[urlRequest setHTTPBody:jsonData];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
}

- (void)delete
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self url] + "/" + [self id]];
	[urlRequest setHTTPMethod:@"DELETE"];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
}

- (void)connection:(CPURLConnection)urlConnection didReceiveData:(CPString)data
{
	if([[urlConnection HTTPMethod] isEqual:@"GET"])
	{
		self = [OLKeyedUnarchiver unarchivedData:data];
	}
	else if([[urlConnection HTTPMethod] isEqual:@"POST"])
	{
		_OId = data;
	}
	else
	{
		[CPException raise:@"Unsupported Operation" reason:@"Received data on a non POST, non GET request!"];
	}
}

- (id)encode:(OLKeyedArchiver)archiver
{
	[archiver encodeNumber:_OId withKey:@"_id"];
	[archiver encodeString:[self class] withKey:@"__class"];
}

- (void)decode:(OLKeyedUnarchiver)unarchiver
{
	_OId = [archiver decodeNumberFromKey:@"_id"];
}

@end