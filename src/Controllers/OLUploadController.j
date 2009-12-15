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
	
		console.log(aResponse);
		
		_jsonResponse = eval('(' + aResponse + ')');
	
		// console.log(_jsonResponse);
		
		[[CPNotificationCenter defaultCenter] postNotificationName:OLUploadControllerDidParseServerResponse object:self];
	} 
	catch (ex)
	{
		console.log(ex);
		[OLException raise:"OLWelcomeController" reason:"it couldn't handle the response from the upload."];
	}
}

@end
