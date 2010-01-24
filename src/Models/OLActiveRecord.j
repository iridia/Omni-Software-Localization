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
	CPURLConnection findAllConnection;
	
	Function        getCallback;
	Function        saveCallback;
	Function        createCallback;
	Function        findByCallback;
	Function        findAllCallback;
	
	CPString        findAllSelector;
	
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
		var modifiedClassName = [self apiClassName];
        var url = @"api/" + modifiedClassName + "/find/all";
		var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
		var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
		var numberCalledBack = 0;
	
		var data = eval('(' + JSONresponse.string + ')');
	
		for(var i = 0; i < [data.rows count]; i++)
		{
			[self findByRecordID:data.rows[i].id withCallback:function(record)
			{
			    callback(record); 
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

		[exception raise];
        
        return [CPArray array];
	}
}

+ (void)find:(CPString)propertyToSearchOn by:(JSON)object callback:(Function)callback
{
	var modifiedClassName = [self apiClassName];
    var url = @"api/" + modifiedClassName + "/find/" + propertyToSearchOn + "?key=\"" + object + "\"";
    
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	
	var JSONresponse = [CPURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
	
	var data = eval('(' + JSONresponse.string + ')');
    
	for(var i = 0; i < [data.rows count]; i++)
	{
		[self findByRecordID:data.rows[i].id withCallback:function(record)
		{
		    callback(record);
		}];
	}
}

+ (void)findByRecordID:(CPString)aRecordID withCallback:(Function)callback
{
	var record = [[self alloc] init];
	[record setRecordID:aRecordID];
	[record getWithCallback:callback];
}

+ (void)findAllBy:(CPString)aString withCallback:(Function)callback
{
    var record = [[self alloc] init];
    [record findAllBy:aString withCallback:callback];
}

- (void)findAllBy:(CPString)aString withCallback:(Function)callback
{
    aString = [aString lowercaseString];
	var modifiedClassName = [[self class] apiClassName];
    var url = @"api/" + modifiedClassName + "/find/all_by_" + modifiedClassName + "_" + aString;
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	[urlRequest setHTTPMethod:"GET"];

    findAllSelector = aString;
    findAllCallback = callback;
	findAllConnection = [OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self];
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
	        case findAllConnection:
	            for(var i = 0; i < [json.rows count]; i++)
	            {
	                var record = [[[self class] alloc] init];
	                [record setRecordID:json.rows[i].id];
	                
	                var selector = CPSelectorFromString("set" + [findAllSelector capitalizedString] + ":");
	                
	                objj_msgSend(record, selector, json.rows[i].value[findAllSelector]);
	                findAllCallback(record);
	            }
	            break;
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
    var modifiedClassName = [[self class] apiClassName];
    var url = @"api/" + modifiedClassName;
    
    if (shouldAppendRecordID)
    {
        url += "/" + _recordID;
    }

    return [CPURL URLWithString:url];
}

+ (CPString)apiClassName
{
    return [self className].replace("OL", "").toLowerCase();
}

@end

// Automagically gives all subclasses a nice search API based on the accessors they have
@implementation OLActiveRecord (SearchAPI)

+ (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    return [self instancesRespondToSelector:[self accessorFromSearchSelector:aSelector]];    
}

+ (void)forwardInvocation:(CPInvocation)anInvocation
{
    var searchSelector = CPSelectorFromString(@"find:by:callback:");
    var accessorString = CPStringFromSelector([self accessorFromSearchSelector:[anInvocation selector]]);
    var searchKey = [anInvocation argumentAtIndex:2];
    var callback = [anInvocation argumentAtIndex:3];
    
    if (searchKey && callback && [self respondsToSelector:searchSelector])
    {
        [anInvocation setSelector:searchSelector];
        [anInvocation setArgument:accessorString atIndex:2];
        [anInvocation setArgument:searchKey atIndex:3];
        [anInvocation setArgument:callback atIndex:4];
    
        for (var i = 5; ; i++)
        {
            var unwantedArg = [anInvocation argumentAtIndex:i];
            if (unwantedArg === nil || (typeof (unwantedArg)) == "undefined")
            {
                break;
            }
            [anInvocation setArgument:nil atIndex:i];            
        }

        [anInvocation invoke];
    }
    else
    {
        [super forwardInvocation:anInvocation];
    }
}

+ (SEL)accessorFromSearchSelector:(SEL)aSelector
{
    var accessors = accessorRegEx.exec(CPStringFromSelector(aSelector));

    if (accessors)
    {
        var accessor = accessors[1];
        accessor = accessor.charAt(0).toLowerCase() + accessor.substring(1);
        return CPSelectorFromString(accessor);
    }
    
    return CPSelectorFromString("VERYBOGUSSELECTOR_1234");
}

@end

var accessorRegEx = new RegExp("findBy(.*?):", "");
