@import <Foundation/CPException.j>

var __createURLConnectionFunction = nil;

@implementation OLException : CPException
{
	CPString _classWithError @accessors(property=classWithError);
	CPString _methodWithError @accessors(property=methodWithError);
	CPString _additionalInformation @accessors(property=additionalInformation);
}

+ (CPURLConnection)createConnectionWithRequest:(CPURLRequest)request delegate:(id)delegate
{
    if(__createURLConnectionFunction == nil)
    {
        return [CPURLConnection connectionWithRequest:request delegate:delegate];
    }

    return __createURLConnectionFunction(request, delegate);
}

+ (CPURLConnection)setConnectionFactoryMethod:(Function)builderMethodWithTwoArguments
{
    __createURLConnectionFunction = builderMethodWithTwoArguments;
}

+ (id)alloc
{
	return class_createInstance(self);
}

- (id)initWithName:(CPString)aName reason:(CPString)aReason userInfo:(CPDictionary)someUserInfo
{
	return [super initWithName:aName reason:aReason userInfo:someUserInfo];
}

- (void)raise
{
	var data = {
		"classWithError":_classWithError,
		"methodWithError":_methodWithError,
		"additionalInformation":_additionalInformation,
		"name":[self name],
		"reason":[self reason]
	};
	
	var req = [CPURLRequest requestWithURL:@"api/error/"];
	[req setHTTPMethod:"PUT"];
    [req setHTTPBody:JSON.stringify(data)];
	var conn = [[self class] createConnectionWithRequest:req delegate:self];
	
	[[[CPApplication sharedApplication] delegate] handleException:self];
}

@end
