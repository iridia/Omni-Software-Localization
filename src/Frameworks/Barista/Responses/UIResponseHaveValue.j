@implementation UIResponseHaveValue : CPObject

+ (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	var value = eval('(\"' + arg + '\")');
	if(value)
	{
		return function()
		{
			var obj = [context objectForKey:@"then"];
			if([[obj stringValue] isEqualToString:value])
			{
				[delegate addSuccess:"Object with tag " + [obj tag] + " had the value " + value];
			}
			else
			{
				[delegate addError:"Object with tag " + [obj tag] + " did not have the value " + value];
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
