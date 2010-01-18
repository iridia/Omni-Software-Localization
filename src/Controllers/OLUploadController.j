@import <Foundation/CPObject.j>

var OLUploadControllerDidParseServerResponse = @"OLUploadControllerDidParseServerResponse";

@implementation OLUploadController : CPObject
{
	JSObject	_jsonResponse	@accessors(property=jsonResponse, readonly);
}

- (void)handleServerResponse:(CPString)aResponse
{
	try
	{
		aResponse = aResponse.replace("<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">", "");
		aResponse = aResponse.replace("\n</pre>", "");
	
        // console.log(aResponse);
		
        _jsonResponse = eval('(' + aResponse + ')');
        
		// console.log(_jsonResponse);
		
        [[CPNotificationCenter defaultCenter] postNotificationName:OLUploadControllerDidParseServerResponse object:self];
	} 
	catch (ex)
	{
	    var exception = [OLException exceptionFromCPException:ex];

        [exception setClassWithError:[self className]];
        [exception setMethodWithError:_cmd];
        [exception setUserMessage:@"Could not handle the response from the server"];
        [exception addUserInfo:aResponse forKey:@"response"];

		[exception raise];
	}
}

@end
