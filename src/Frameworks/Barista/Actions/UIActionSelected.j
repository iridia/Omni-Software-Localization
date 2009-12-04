@implementation UIActionSelected : CPObject

- (Function)parse:(CPString)arg context:(CPDictionary)context delegate:(id)delegate
{
	if(arg)
	{
		if(arg.match(/on row (.+)/))
		{
			return function()
			{
				var obj = [context objectForKey:@"when"];
				var number = eval('(' + arg.match(/on row (.+)/)[1] + ')');
			
				[[[obj content] objectForIndex:number] setSelected:self];
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
	else
	{
		return function()
		{
			var obj = [context objectForKey:@"when"];
			[[[obj content] objectForIndex:0] setSelected:self];
		};
	}
}

@end
