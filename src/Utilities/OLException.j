@import <Foundation/CPException.j>
@import "OLURLConnectionFactory.j"
@import "OLJSONKeyedArchiver.j"

@implementation OLException : CPException
{
	CPString    classWithError      @accessors;
	CPString    methodWithError     @accessors;
	CPString    userMessage         @accessors;
}

+ (id)alloc
{
    return class_createInstance(self);
}

+ (id)exceptionFromCPException:(CPException)exception
{
    return [[OLException alloc] initWithName:[exception name] reason:[exception reason] userInfo:[CPDictionary dictionary]];
}

- (void)setClass:(CPString)className WithMethod:(CPString)methodName AndUserMessage:(CPString)message
{
    classWithError = className;
    methodWithError = methodName;
    userMessage = message;
}

- (void)raise
{
    var data = [OLJSONKeyedArchiver archivedDataWithRootObject:self];
    
	var req = [CPURLRequest requestWithURL:@"api/error/"];
	[req setHTTPMethod:"PUT"];
    [req setHTTPBody:JSON.stringify(data)];
	var conn = [OLURLConnectionFactory createConnectionWithRequest:req delegate:self];
	
	[[[CPApplication sharedApplication] delegate] handleException:self];
}

- (void)addUserInfo:(id)info forKey:(CPString)aKey
{
    [[self userInfo] setObject:info forKey:aKey];
}

@end

var OLExceptionClassKey = @"OLExceptionClassKey";
var OLExceptionMethodKey = @"OLExceptionMethodKey";
var OLExceptionUserMessageKey = @"OLExceptionUserMessageKey";

@implementation OLException (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        classWithError = [aCoder decodeObjectForKey:OLExceptionClassKey];
        methodWithError = [aCoder decodeObjectForKey:OLExceptionMethodKey];
        userMessage = [aCoder decodeObjectForKey:OLExceptionUserMessageKey];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:classWithError forKey:OLExceptionClassKey];
    [aCoder encodeObject:methodWithError forKey:OLExceptionMethodKey];
    [aCoder encodeObject:userMessage forKey:OLExceptionUserMessageKey];
}

@end