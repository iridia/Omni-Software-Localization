@implementation UIResponseSelect : CPObject

+ (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	return function()
	{
		if(arg.match(/Select row (.+)/))
		{
			var num = eval('(' + arg.match(/Select row (.+)/)[1] + ')');
			if(num)
			{
				return function()
				{
					var obj = [context objectForKey:@"then"];
					if([[obj selectionIndexes] containsIndex:num])
					{
						[delegate addSuccess:"Object with tag " + [obj tag] + " had the " + num + "th index selected"];
					}
					else
					{
						[delegate addError:"Object with tag " + [obj tag] + " did not have the " + num + "th index selected"]
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
	};
}

@end
