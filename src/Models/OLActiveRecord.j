@import <Foundation/CPObject.j>

@import "../Utilities/OLJSONKeyedArchiver.j"
@import "../Utilities/OLJSONKeyedUnarchiver.j"
@import "../Utilities/OLException.j"
@import "../Utilities/OLURLConnectionFactory.j"

var __createURLConnectionFunction = nil;

@implementation OLActiveRecord : CPObject
{
	CPString _recordID @accessors(property=recordID);
	CPString _revision @accessors(property=revision);

	CPURLConnection _saveConnection;
	CPURLConnection _createConnection;
	CPURLConnection _getConnection;
	CPURLConnection _listConnection;
	CPURLConnection findByConnection;
	
	Function        getCallback;
	Function        saveCallback;
	Function        createCallback;
	Function        findByCallback;
	
	id _delegate @accessors(property=delegate);
}

/*
 * This has a special callback requirement. Because we want our lists to load when available (rather than when all are loaded)
 * we need this callback to ADD to a list rather than SET a list. Expect a single record as an argument!
 */
+ (void)listWithCallback:(Function)callback
{
    [self listWithCallback:callback finalCallback:function(){}];
}

+ (void)listWithCallback:(Function)callback finalCallback:(Function)finalCallback
{
	try
	{
		var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
	    var url = @"api/" + modifiedClassName + "/_design/finder/_view/find";
		var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
		var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
		var numberCalledBack = 0;
	
		var data = eval('(' + JSONresponse.string + ')');
	
		for(var i = 0; i < [data.rows count]; i++)
		{
			[self findByRecordID:data.rows[i].id withCallback:function(user)
			{
			    callback(user); 
			    numberCalledBack++; 
			    if(numberCalledBack == [data.rows count]) 
			    {
			        finalCallback();
			    }
			}];
		}
		
		if([data.rows count] == 0)
		{
		    finalCallback();
		}
	}
	catch(ex)
	{
        var exception = [OLException exceptionFromCPException:ex];

        [exception setClassWithError:[self className]];
        [exception setMethodWithError:_cmd];
        [exception setUserMessage:@"Could not finish the request to the server"];
        [exception addUserInfo:callback forKey:@"callback"];
        [exception addUserInfo:finalCallback forKey:@"finalCallback"];

		[exception raise];
        
        return [CPArray array];
	}
}

+ (void)find:(CPString)propertyToSearchOn by:(JSON)object callback:(Function)callback
{
	var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
    var url = @"api/" + modifiedClassName + "/_design/finder/_view/find_by_" + propertyToSearchOn + "?key=" + object;
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	
	findByCallback = callback;
    findByConnection = [OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self];
}

+ (void)findByRecordID:(CPString)aRecordID withCallback:(Function)callback
{
	var record = [[self alloc] init];
	[record setRecordID:aRecordID];
	[record getWithCallback:callback];
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

- (void)getWithCallback:(Function)callback
{
	try
	{
	    getCallback = callback;
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"GET"];
	
    	_getConnection = [OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self];
	}
	catch(ex)
	{
        var exception = [OLException exceptionFromCPException:ex];

        [exception setClassWithError:[self className]];
        [exception setMethodWithError:_cmd];
        [exception setUserMessage:@"Could not retrieve the requested data from the database"];
        [exception addUserInfo:callback forKey:@"callback"];

		[exception raise];
        
        return [[CPObject alloc] init];
	}
}

- (void)save
{
    [self saveWithCallback:function(){}];
}

- (void)saveWithCallback:(Function)callback
{
	if (!_recordID)
	{
        [self _createWithCallback:callback];
	}
	else
	{	
		try
		{
			var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
			[urlRequest setHTTPMethod:"POST"];
	
            var archivedJSON = [OLJSONKeyedArchiver archivedDataWithRootObject:self];
            archivedJSON["_rev"] = _revision;
                     
            [urlRequest setHTTPBody:JSON.stringify(archivedJSON)];
	
	    	saveCallback = callback;
	    	_saveConnection = [OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self];
		}
		catch(ex)
		{
            var exception = [OLException exceptionFromCPException:ex];

            [exception setClassWithError:[self className]];
            [exception setMethodWithError:_cmd];
            [exception setUserMessage:@"Could not save the data to the database"];
            [exception addUserInfo:callback forKey:@"callback"];

    		[exception raise];
		}
    }    
}

- (void)_createWithCallback:(Function)callback
{
	try
	{
	    var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:NO]];
		[urlRequest setHTTPMethod:"PUT"];

	    var archivedJSON = [OLJSONKeyedArchiver archivedDataWithRootObject:self];
	    [urlRequest setHTTPBody:JSON.stringify(archivedJSON)];
	
		if ([_delegate respondsToSelector:@selector(willCreateRecord:)])
		{
		    [_delegate willCreateRecord:self];
		}
		
		createCallback = callback;
		_createConnection = [OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self];
	}
	catch(ex)
	{
        var exception = [OLException exceptionFromCPException:ex];

        [exception setClassWithError:[self className]];
        [exception setMethodWithError:_cmd];
        [exception setUserMessage:@"Could not create the data on the server"];
        [exception addUserInfo:callback forKey:@"callback"];

		[exception raise];
	}
}

- (void)delete
{
	try
	{
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"DELETE"];
	
		[[self class] createConnectionWithRequest:urlRequest delegate:nil];
	}
	catch(ex)
	{
        var exception = [OLException exceptionFromCPException:ex];

        [exception setClassWithError:[self className]];
        [exception setMethodWithError:_cmd];
        [exception setUserMessage:@"Could not delete the data from the database"];

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
	        case findByConnection:
            	for(var i = 0; i < [json.rows count]; i++)
            	{
            		[self findByRecordID:json.rows[i].id withCallback:function(user)
            		{
            		    findByCallback(user); 
            		}];
            	}
            	break;
	        case _createConnection:
	            _recordID = json["id"];
	            _revision = json["rev"];
	            if ([_delegate respondsToSelector:@selector(didCreateRecord:)])
	        	{
	        	    [_delegate didCreateRecord:self];
	        	}
	        	createCallback(self);
	            break;
	        case _saveConnection:
	            _revision = json["rev"] || _revision;
	            saveCallback(self);
	            break;
	        case _getConnection:
        		// Unarchive the data
        		var rootObject = [OLJSONKeyedUnarchiver unarchiveObjectWithData:json];

        		[rootObject setRevision:json._rev];
        		[rootObject setRecordID:json._id];
        		
        		try
        		{
        		    getCallback(rootObject);
    		    }
    		    catch(ex)
    		    {
            		var exception = [OLException exceptionFromCPException:ex];

                    [exception setClassWithError:[self className]];
                    [exception setMethodWithError:_cmd];
                    [exception setUserMessage:@"Could not handle the response from the server"];
                    [exception addUserInfo:data forKey:@"response"];
                    [exception addUserInfo:rootObject forKey:@"rootObject"];
                    [exception addUserInfo:@"get" forKey:@"connectionType"];

            		[exception raise];
    		    }
    		    
	            break;
	        default:
	            break;
	    }
	}
	catch(ex)
	{
        var exception = [OLException exceptionFromCPException:ex];
         
        [exception setClassWithError:[self className]];
        [exception setMethodWithError:_cmd];
        [exception setUserMessage:@"Could not handle response form server"];
        [exception addUserInfo:data forKey:@"response"];
        
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
