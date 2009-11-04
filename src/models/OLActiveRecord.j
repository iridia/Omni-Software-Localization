@import <Foundation/CPObject.j>
@import <Foundation/CPKeyedArchiver.j>

@implementation OLActiveRecord : CPObject
{
	CPString _recordID @accessors(property=RecordID);
	
	CPURLConnection _saveConnection;
	CPURLConnection _createConnection;
	
	id _delegate @accessors(property=delegate);
}

+ (OLActiveRecord)findByRecordID:(CPString)aRecordID
{
	var record = [self init];
	[record setRecordID:aRecordID];
	[record get];
	return record;
}

+ (CPArray)find
{
	var records = [CPArray array];

	var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:NO]];
	[urlRequest setHTTPMethod:"GET"];
	
	var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	var response = eval('(' + JSONresponse + ')');
	
	// some unarchiving stuff
	
	return records;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _recordID = nil;
        _delegate = nil;
    }
    
    return self;
}

- (id)get
{
	var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
	[urlRequest setHTTPMethod:"GET"];
	
	var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	var response = eval('(' + JSONresponse + ')');
	
	// some unarchiving stuff, this depends on how couch sends it back, this is unknown
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
    	[urlRequest setHTTPBody:archivedData];
	
    	_saveConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
    }    
}

- (void)_create
{
    var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:NO]];
	[urlRequest setHTTPMethod:"PUT"];

    var archivedData = [[CPKeyedArchiver archivedDataWithRootObject:self] string];
    [urlRequest setHTTPBody:archivedData];
	
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
