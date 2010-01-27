@import <Foundation/CPObject.j>

@import "../Utilities/OLJSONKeyedArchiver.j"
@import "../Utilities/OLJSONKeyedUnarchiver.j"
@import "../Utilities/OLException.j"
@import "../Utilities/OLURLConnectionFactory.j"

var __createURLConnectionFunction = nil;
var API_PREFIX = "api/";

var SaveConnection = @"SaveConnection";
var CreateConnection = @"CreateConnection";
var GetConnection = @"GetConnection";
var ListConnection = @"ListConnection";
var SearchConnection = @"SearchConnection";
var SearchAllConnection = @"SearchAllConnection";

var OLActiveRecordRevisionKey = @"_rev";
var OLActiveRecordRecordIDKey = @"_id";


@implementation OLActiveRecord : CPObject
{
	CPString        recordID    @accessors;
	CPString        revision    @accessors;
	
	CPDictionary    connections;
	
	id              delegate    @accessors;
}

+ (void)listWithCallback:(Function)callback
{
    var instance = [[self alloc] init];
    [instance _listWithCallback:callback];
}

- (void)_listWithCallback:(Function)callback
{
	try
	{
        var url = API_PREFIX + apiNameFromClass([self class]) + "/find/all";
		var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
		
		var options = [CPDictionary dictionaryWithObjects:[callback, ListConnection] forKeys:[@"callback", @"type"]];
    	[connections setObject:options forKey:[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self]];
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

- (id)init
{
    self = [super init];
    
    if (self)
    {
        connections = [CPDictionary dictionary];
    }
    
    return self;
}

- (void)getWithCallback:(Function)callback
{
	try
	{
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self _apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"GET"];
    	
    	var options = [CPDictionary dictionaryWithObjects:[callback, GetConnection] forKeys:[@"callback", @"type"]];
    	[connections setObject:options forKey:[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self]];
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
	if (![self recordID])
	{
        [self _createWithCallback:callback];
	}
	else
	{	
		try
		{
			var urlRequest = [[CPURLRequest alloc] initWithURL:[self _apiURLWithRecordID:YES]];
			[urlRequest setHTTPMethod:"POST"];
	
            var archivedJSON = [OLJSONKeyedArchiver archivedDataWithRootObject:self];
            archivedJSON[OLActiveRecordRevisionKey] = [self revision];
                     
            [urlRequest setHTTPBody:JSON.stringify(archivedJSON)];

	    	var options = [CPDictionary dictionaryWithObjects:[callback, SaveConnection] forKeys:[@"callback", @"type"]];
	    	[connections setObject:options forKey:[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self]];
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
	    var urlRequest = [[CPURLRequest alloc] initWithURL:[self _apiURLWithRecordID:NO]];
		[urlRequest setHTTPMethod:"PUT"];

	    var archivedJSON = [OLJSONKeyedArchiver archivedDataWithRootObject:self];
	    [urlRequest setHTTPBody:JSON.stringify(archivedJSON)];
	
		if ([[self delegate] respondsToSelector:@selector(willCreateRecord:)])
		{
		    [[self delegate] willCreateRecord:self];
		}
		
		var options = [CPDictionary dictionaryWithObjects:[callback, CreateConnection] forKeys:[@"callback", @"type"]];
    	[connections setObject:options forKey:[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self]];
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
		var urlRequest = [[CPURLRequest alloc] initWithURL:[self _apiURLWithRecordID:YES]];
		[urlRequest setHTTPMethod:"DELETE"];
	
    	[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:nil];
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

- (CPURL)_apiURLWithRecordID:(BOOL)shouldAppendRecordID
{
    var url = API_PREFIX + apiNameFromClass([self class]);
    
    if (shouldAppendRecordID)
    {
        url += "/" + [self recordID];
    }

    return [CPURL URLWithString:url];
}

@end


@implementation OLActiveRecord (SearchAPI)

+ (void)find:(CPString)property by:(JSON)searchParameter withCallback:(Function)callback
{
    var instance = [[self alloc] init];
    [instance _find:property by:searchParameter withCallback:callback];
}

- (void)_find:(CPString)propertyToSearchOn by:(JSON)object withCallback:(Function)callback
{
    var url = API_PREFIX + apiNameFromClass([self class]) + "/find/" + propertyToSearchOn + "?key=\"" + object + "\"";
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	
	var options = [CPDictionary dictionaryWithObjects:[callback, SearchConnection] forKeys:[@"callback", @"type"]];
	[connections setObject:options forKey:[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self]];
}

+ (void)findByRecordID:(CPString)aRecordID withCallback:(Function)callback
{
	var record = [[self alloc] init];
	[record setRecordID:aRecordID];
	[record getWithCallback:callback];
}

+ (void)findAllBy:(CPString)property withCallback:(Function)callback
{
    var record = [[self alloc] init];
    [record _findAllBy:property withCallback:callback];
}

- (void)_findAllBy:(CPString)property withCallback:(Function)callback
{
    property = [property lowercaseString];
    var modifiedClassName = apiNameFromClass([self class]);
    var url = API_PREFIX + modifiedClassName + "/find/all_by_" + modifiedClassName + "_" + property;
	var urlRequest = [[CPURLRequest alloc] initWithURL:[CPURL URLWithString:url]];
	[urlRequest setHTTPMethod:"GET"];
	
	var setSelector = CPSelectorFromString([CPString stringWithFormat:@"set%s:", [property capitalizedString]]);
	var options = [CPDictionary dictionaryWithObjects:[callback, SearchAllConnection, setSelector, property]
	                    forKeys:[@"callback", @"type", @"SetSelector", @"SearchProperty"]];
	[connections setObject:options forKey:[OLURLConnectionFactory createConnectionWithRequest:urlRequest delegate:self]];
}

@end


@implementation OLActiveRecord (CPURLConnectionDelegate)

- (void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
    var options = [connections objectForKey:connection];
    var type = [options objectForKey:@"type"];
    var callback = [options objectForKey:@"callback"];
    
	try
	{
	    var json = eval('(' + data + ')');
	    switch (type)
	    {
	        case ListConnection:
	            if (json.rows.length === 0)
	            {
	                callback(nil, YES);
	            }
	            
        		for (var i = 0; i < json.rows.length; i++)
        		{
        		    var objectJSON = json.rows[i].value;
        		    
        		    var decodedObject = [self _objectFromJSON:objectJSON];
            		
            		callback(decodedObject, (i === json.rows.length - 1));
        		}
        		break;

	        case SearchAllConnection:
	            for(var i = 0; i < json.rows.length; i++)
	            {
	                var row = json.rows[i];
	                
	                var record = [[[self class] alloc] init];
	                [record setRecordID:row.id];
	                
	                var setSelector = [options objectForKey:@"SetSelector"];
	                var searchProperty = [options objectForKey:@"SearchProperty"];
	                
	                [record performSelector:setSelector withObject:row.value[searchProperty]];
	                callback(record, (i === json.rows.length - 1));
	            }
	            
	            break;

	        case SearchConnection:
            	for(var i = 0; i < json.rows.length; i++)
            	{
            		var decodedObject = [self _objectFromJSON:json.rows[i].value];
            		callback(decodedObject, (i === json.rows.length - 1));
            	}
            	break;

	        case CreateConnection:
	            [self setRecordID:json["id"]];
	            [self setRevision:json["rev"]];
	            if ([[self delegate] respondsToSelector:@selector(didCreateRecord:)])
	        	{
	        	    [[self delegate] didCreateRecord:self];
	        	}
	        	callback(self, YES);
	            break;

	        case SaveConnection:
	            var newRev = json["rev"] || [self revision];
	            [self setRevision:newRev];
	            callback(self, YES);
	            break;

	        case GetConnection:
        		var decodedObject = [self _objectFromJSON:json];
        		
        		try
        		{
        		    callback(decodedObject, YES);
    		    }
    		    catch(ex)
    		    {
            		var exception = [OLException exceptionFromCPException:ex];

                    [exception setClassWithError:[self className]];
                    [exception setMethodWithError:_cmd];
                    [exception setUserMessage:@"Could not handle the response from the server"];
                    [exception addUserInfo:data forKey:@"response"];
                    [exception addUserInfo:decodedObject forKey:@"rootObject"];
                    [exception addUserInfo:@"get" forKey:@"connectionType"];

            		[exception raise];
    		    }
	            break;

	        default:
	            CPLog.warn("Unhandled case: %s in %s for class %s", type, _cmd, [self className]);
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


// Properly unarchives an object.
- (id)_objectFromJSON:(JSON)json
{
    var rootObject = [OLJSONKeyedUnarchiver unarchiveObjectWithData:json];
    [rootObject setRevision:json[OLActiveRecordRevisionKey]];
    [rootObject setRecordID:json[OLActiveRecordRecordIDKey]];
    
    return rootObject;
}

@end


// Automagically gives all subclasses a nice search API based on the accessors they have
@implementation OLActiveRecord (ForwardingForSearchAPI)

// Right now, objj doesn't have method signatures, so we just need to return a truthy value
// to let the forwarding know we want to forward
+ (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    var accessor = getAccessorForSelector(_cmd, self, aSelector);
    return (accessor && [self instancesRespondToSelector:accessor]);    
}

// Does all the work to forward the message to the right selector.
+ (void)forwardInvocation:(CPInvocation)anInvocation
{
    var accessorString = CPStringFromSelector(getAccessorForSelector(_cmd, self, [anInvocation selector]));
    var apiSelector = getAPIMethodForSelector(_cmd, self, [anInvocation selector]);
    
    if (CPStringFromSelector(apiSelector) === searchAPIMethod)
    {
        var searchKey = [anInvocation argumentAtIndex:2];
        var callback = [anInvocation argumentAtIndex:3];
    
        if (searchKey && callback)
        {
            [anInvocation setSelector:apiSelector];
            [anInvocation setArgument:accessorString atIndex:2];
            [anInvocation setArgument:searchKey atIndex:3];
            [anInvocation setArgument:callback atIndex:4];
    
            removeAllArgumentsFromInvocationAboveIndex(anInvocation, 5);

            [anInvocation invoke];
        }
    }
    else if (CPStringFromSelector(apiSelector) === findAllAPIMethod)
    {
        var callback = [anInvocation argumentAtIndex:2];
        
        if (callback)
        {
            [anInvocation setSelector:apiSelector];
            [anInvocation setArgument:accessorString atIndex:2];
            [anInvocation setArgument:callback atIndex:3];
    
            removeAllArgumentsFromInvocationAboveIndex(anInvocation, 4);

            [anInvocation invoke];  
        }
    }
    else
    {
        [super forwardInvocation:anInvocation];
    }
}

@end

// Private variables and functions for forwarding
var searchAccessorRegEx = new RegExp("findBy(.*?):withCallback:", "");
var searchAPIMethod = @"find:by:withCallback:";
var findAllAPIMethod = @"findAllBy:withCallback:";

// Gets the accessor method (the getter) for the given selector
// You can then test to see if you respond to this selector
function getAccessorForSelector(_cmd, self, aSelector)
{
    var selectorString = CPStringFromSelector(aSelector);
    
    // Are we of the form findBy<getter>:callback: ??
    var accessors = searchAccessorRegEx.exec(selectorString);
    if (accessors)
    {
        return getAccessorFromAccessors(accessors);
    }

    // Are we of the form findAll<model>sBy<getter>WithCallback:
    var searchAllAccessorRegEx = getFindAllRegExpForModel(apiNameFromClass(self));
    var accessors = searchAllAccessorRegEx.exec(selectorString);
    if (accessors)
    {
        return getAccessorFromAccessors(accessors);
    }

    return NO;
}

// Converts the selector into the desired API method on OLActiveRecord
function getAPIMethodForSelector(_cmd, self, aSelector)
{
    var selectorString = CPStringFromSelector(aSelector);
    
    // Are we of the form findBy<getter>:callback: ??
    var accessors = searchAccessorRegEx.exec(selectorString);
    if (accessors)
    {
        return CPSelectorFromString(searchAPIMethod);
    }

    // Are we of the form findAll<model>sBy<getter>WithCallback:
    var searchAllAccessorRegEx = getFindAllRegExpForModel(apiNameFromClass(self));
    var accessors = searchAllAccessorRegEx.exec(selectorString);
    if (accessors)
    {
        return CPSelectorFromString(findAllAPIMethod);
    }
    
    // Return a bogus selector. Technically we should never get here, but just in case...
    return CPSelectorFromString(@"__WESHOULDNEVERGETHERE__");
}

// Transform what was pulled from the selector into an actual accessor
// Basically just makes the first letter lowercase
function getAccessorFromAccessors(accessors)
{
    var accessor = accessors[1];
    return CPSelectorFromString((accessor.charAt(0).toLowerCase() + accessor.substring(1)));
}

// Build a regex based on the model string (i.e. converts project into Project)
function getFindAllRegExpForModel(aModel)
{
    return new RegExp("findAll" + [aModel capitalizedString] + "sBy(.*?)WithCallback:", "");
}

// If an invocation object has extra params., get rid of them
function removeAllArgumentsFromInvocationAboveIndex(anInvocation, startingIndex)
{
    for (var i = startingIndex; ; i++)
    {
        var unwantedArg = [anInvocation argumentAtIndex:i];
        if (unwantedArg === nil || (typeof (unwantedArg)) == "undefined")
        {
            break;
        }
        [anInvocation setArgument:nil atIndex:i];            
    }
}


// Other private functions

// Convert a class into the api string
function apiNameFromClass(aClass)
{
    return CPStringFromClass(aClass).replace("OL", "").toLowerCase();
}
