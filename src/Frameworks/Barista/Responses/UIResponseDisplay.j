@implementation UIResponseDisplay : CPObject

+ (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	return function()
	{
		var obj = [context objectForKey:@"then"];
		if(obj)
		{
			[delegate addSuccess:"Object with key " + [obj tag] + " was correctly displayed."];
		}
		else
		{
			[delegate addError:"Object with key " + [obj tag] + " was not displayed."];
		}
	};
}

@end
