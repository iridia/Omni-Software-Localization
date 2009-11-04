@import <Foundation/CPObject.j>
@import <Foundation/CPKeyedArchiver.j>

@implementation OLActiveRecord : CPObject
{
	CPString _recordID @accessors(property=recordID);
	CPString _revision @accessors(property=revision);
	
	CPURLConnection _saveConnection;
	CPURLConnection _createConnection;
	
	id _delegate @accessors(property=delegate);
}

+ (CPArray)list
{
	var records = [CPArray array];
	
	var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
    var url = @"api/" + modifiedClassName + "/_all_docs";
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	var JSONresponse = [[CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil]];
	
	var data = eval('(' + JSONresponse[0].string + ')');
	
	for(var i = 0; i < [data.rows count]; i++)
	{
		[records addObject:[self findByRecordID:data.rows[i].id]];
	}

	return records;
}

+ (OLActiveRecord)findByRecordID:(CPString)aRecordID
{
	var record = [[self alloc] init];
	[record setRecordID:aRecordID];
	var newRecord = [record get];
	return newRecord;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _recordID = nil;
        _revision = nil;
        _delegate = nil;
    }
    
    return self;
}

- (id)get
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
	[urlRequest setHTTPMethod:"GET"];
	
	var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	var response = eval('(' + JSONresponse.string + ')');
	
	// Unarchive the data
	var archivedString = response.archive;
	var archivedData = [CPData dataWithString:archivedString];
	var rootObject = [CPKeyedUnarchiver unarchiveObjectWithData:archivedData];
	
	[rootObject setRevision:response._rev];
	[rootObject setRecordID:response._id];
	
	return rootObject;
}

- (void)save
{
	if (!_recordID)
	{
        [self _create];
	}
	else
	{		
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"POST"];
		
        var archivedData = [[CPKeyedArchiver archivedDataWithRootObject:self] string];
        var jsonedData = JSON.stringify({"_rev": _revision, "archive":archivedData});
    	[urlRequest setHTTPBody:jsonedData];
	
    	_saveConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
    }    
}

- (void)_create
{
    var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:NO]];
	[urlRequest setHTTPMethod:"PUT"];

    var archivedData = [[CPKeyedArchiver archivedDataWithRootObject:self] string];
    var jsonedData = JSON.stringify({"archive":archivedData});
    [urlRequest setHTTPBody:jsonedData];
	
	if ([_delegate respondsToSelector:@selector(willCreateRecord:)])
	{
	    [_delegate willCreateRecord:self];
	}
	
	_createConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void)delete
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
	[urlRequest setHTTPMethod:"DELETE"];
	
	[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    switch (connection)
    {
        case _createConnection:
            _recordID = data["_id"];
            if ([_delegate respondsToSelector:@selector(didCreateRecord:)])
        	{
        	    [_delegate didCreateRecord:self];
        	}
            break;
        default:
            break;
    }
}

- (CPURL)apiURLWithRecordID:(BOOL)shouldAppendRecordID
{
    var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
    var url = @"api/" + modifiedClassName;
    
    if (shouldAppendRecordID)
    {
        url += "/" + _recordID;
    }

    return [CPURL URLWithString:url];
}

@end
