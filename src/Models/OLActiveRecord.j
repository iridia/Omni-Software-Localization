@import <Foundation/CPObject.j>
@import <Foundation/CPKeyedArchiver.j>
@import "../Utilities/OLException.j"

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
	try
	{
		var records = [CPArray array];
	
		var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
	    var url = @"api/" + modifiedClassName + "/_all_docs";
		var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
		var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
		var data = eval('(' + JSONresponse.string + ')');
	
		for(var i = 0; i < [data.rows count]; i++)
		{
			[records addObject:[self findByRecordID:data.rows[i].id]];
		}

		return records;
	}
	catch(ex)
	{
		var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
			reason:"it was unable to finish the request to the server" userInfo:[CPDictionary dictionary]];

		//[exception setClassWithError:[self class]];
		[exception setMethodWithError:@"list"];
		//[exception setAdditionalInformation:ex];

		[exception raise];
		
		return [CPArray array];
	}
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
	try
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
	catch(ex)
	{
		var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
			reason:@"it was unable to complete the request to the api" userInfo:[CPDictionary dictionary]];
			
		//[exception setClassWithError:[self class]];
		[exception setMethodWithError:@"get"];
		//[exception setAdditionalInformation:ex];
		
		[exception raise];
		
		return [[CPObject alloc] init];
	}
}

- (void)save
{
	if (!_recordID)
	{
        [self _create];
	}
	else
	{	
		try
		{
			var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
			[urlRequest setHTTPMethod:"POST"];
		
	        var archivedData = [[CPKeyedArchiver archivedDataWithRootObject:self] string];
	        var jsonedData = JSON.stringify({"_rev": _revision, "archive":archivedData});
	    	[urlRequest setHTTPBody:jsonedData];
	
	    	_saveConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
		}
		catch(ex)
		{
			var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
				reason:"it was unable to finish the request to the server" userInfo:[CPDictionary dictionary]];

			//[exception setClassWithError:[self class]];
			[exception setMethodWithError:@"save"];
			//[exception setAdditionalInformation:ex];

			[exception raise];
		}
    }    
}

- (void)_create
{
	try
	{
	    var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:NO]];
		[urlRequest setHTTPMethod:"PUT"];
		
		console.log("Here1", self);

	    var archivedData = [[CPKeyedArchiver archivedDataWithRootObject:self] string];
		
		console.log("Here2");
	    var jsonedData = JSON.stringify({"archive":archivedData});
		console.log("Here3");
	    [urlRequest setHTTPBody:jsonedData];
	
		if ([_delegate respondsToSelector:@selector(willCreateRecord:)])
		{
		    [_delegate willCreateRecord:self];
		}
		
		_createConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
	}
	catch(ex)
	{
		console.log(ex);
		var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
			reason:"it was unable to finish the request to the server" userInfo:[CPDictionary dictionary]];

		//[exception setClassWithError:[self class]];
		[exception setMethodWithError:@"create"];
		//[exception setAdditionalInformation:ex];

		[exception raise];
	}
}

- (void)delete
{
	try
	{
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"DELETE"];
	
		[[CPURLConnection alloc] initWithRequest:urlRequest delegate:nil startImmediately:YES];
	}
	catch(ex)
	{
		var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
			reason:"it was unable to finish the request to the server" userInfo:[CPDictionary dictionary]];
			
		//[exception setClassWithError:[self class]];
		[exception setMethodWithError:@"delete"];
		//[exception setAdditionalInformation:ex];
		
		[exception raise];		
	}
}

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
	try
	{
	    var json = eval('(' + data + ')');
    
	    switch (connection)
	    {
	        case _createConnection:
	            _recordID = json["id"];
	            _revision = json["rev"];
	            if ([_delegate respondsToSelector:@selector(didCreateRecord:)])
	        	{
	        	    [_delegate didCreateRecord:self];
	        	}
	            break;
	        case _saveConnection:
	            _revision = json["rev"] || _revision;
	            break;
	        default:
	            break;
	    }
	}
	catch(ex)
	{
		var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
			reason:"it was unable to handle the response from the server" userInfo:[CPDictionary dictionary]];
			
		///[exception setClassWithError:""+[self class]];
		[exception setMethodWithError:@"get"];
		//[exception setAdditionalInformation:ex];
		
		[exception raise];
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
