@import <Foundation/CPObject.j>

@import "../Utilities/OLJSONKeyedArchiver.j"
@import "../Utilities/OLJSONKeyedUnarchiver.j"
@import "../Utilities/OLException.j"

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

+ (CPURLConnection)createURLConnectionWithRequest:(CPURLRequest)request delegate:(id)delegate
{
    if(__createURLConnectionFunction == nil)
    {
        return [CPURLConnection connectionWithRequest:request delegate:delegate];
    }
    
    return __createURLConnectionFunction(request, delegate);
}

+ (CPURLConnection)setURLConnectionBuilderMethod:(Function)builderMethodWithTwoArguments
{
    __createURLConnectionFunction = builderMethodWithTwoArguments;
}

+ (CPArray)list
{
    var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
    	reason:@"it was unable to complete the request to the api" userInfo:[CPDictionary dictionary]];
	
    //[exception setClassWithError:[self class]];
    [exception setMethodWithError:@"list"];
    //[exception setAdditionalInformation:"List is deprecated, use listWithCallback"];

    [exception raise];
}

+ (void)listWithCallback:(Function)callback
{
    [self listWithCallback:callback finalCallback:function(){}];
}

/*
 * This has a special callback requirement. Because we want our lists to load when available (rather than when all are loaded)
 * we need this callback to ADD to a list rather than SET a list. Expect a single record as an argument!
 */
+ (void)listWithCallback:(Function)callback finalCallback:(Function)finalCallback
{
	try
	{
		var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
	    var url = @"api/" + modifiedClassName + "/_design/finder/_views/find";
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

+ (void)find:(CPString)propertyToSearchOn by:(JSON)object callback:(Function)callback
{
	var modifiedClassName = class_getName([self class]).replace("OL","").toLowerCase();
    var url = @"api/" + modifiedClassName + "/_design/finder/_view/find_by_" + propertyToSearchOn + "?key=" + object;
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	
	findByCallback = callback;
    findByConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
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

- (id)get
{
	var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
		reason:@"it was unable to complete the request to the api" userInfo:[CPDictionary dictionary]];
		
	//[exception setClassWithError:[self class]];
	[exception setMethodWithError:@"get"];
	//[exception setAdditionalInformation:"Get is deprecated, use getWithCallback"];
	
	[exception raise];
}

- (void)getWithCallback:(Function)callback
{
	try
	{
	    getCallback = callback;
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"GET"];
	
    	_getConnection = [CPURLConnection connectionWithRequest:urlRequest delegate:self];
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
            		var exception = [[OLException alloc] initWithName:@"OLActiveRecord" 
            			reason:"the provided callback threw an error" userInfo:[CPDictionary dictionary]];

            		///[exception setClassWithError:""+[self class]];
            		[exception setMethodWithError:@"get"];
            		//[exception setAdditionalInformation:ex];

            		[exception raise];
    		    }
    		    
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
