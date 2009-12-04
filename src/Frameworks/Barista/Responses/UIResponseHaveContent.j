@implementation UIResponseHaveContent : CPObject

+ (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	var array = eval('([' + arg + '])');
	if(array)
	{
		return function()
		{
			var obj = [context objectForKey:@"then"];
			if([[obj content] isEqualToArray:array])
			{
				[delegate addSuccess:"Object with tag " + [obj tag] + " had the content " + array];
			}
			else
			{
				[delegate addError:"Object with tag " + [obj tag] + " did not have the content " + array];
			}
		};
	}
	else
	{
		return function()
		{
			[delegate addError:"Was unable to parse the line " + lineData];
		};
	}
}

@end
