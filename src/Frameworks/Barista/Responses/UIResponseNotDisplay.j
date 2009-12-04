@implementation UIResponseNotDisplay : CPObject

+ (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	return function()
	{
		var obj = [context objectForKey:@"then"];
		if(!obj)
		{
			[delegate addSuccess:"Object with key " + [obj tag] + " was correctly not displayed."];
		}
		else
		{
			[delegate addError:"Object with key " + [obj tag] + " was displayed, which was incorrect."];
		}
	};
}

@end
