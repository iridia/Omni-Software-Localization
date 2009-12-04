
@implementation UIActionClicked : CPObject

+ (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	return function()
	{
		var obj = [context objectForKey:@"when"];
		[obj performClick:self];
	};
}

@end
