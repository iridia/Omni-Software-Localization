@import "Actions/UIActions.j"
@import "Responses/UIResponses.j"

@implementation UITestScriptParser : CPObject

+ (CPArray)parse:(CPString)fileData withDelegate:(UITestScript)delegate
{
	var context = [CPDictionary dictionary];
	var data = fileData.split("\n");
	var loadedData = [CPArray array];
	
	for(var i = 0; i < [data count]; i++)
	{
		if([data objectAtIndex:i].match(@"^#") || [data objectAtIndex:i].match(/^\//) 
			|| [data objectAtIndex:i].match(/^Comment/) || [data objectAtIndex:i].match(/^\s*$/))
		{
			continue;
		}
		
		[loadedData addObject:[UITestScriptParser parseLine:[data objectAtIndex:i] withContext:context delegate:delegate]];
	}
	
	return loadedData;
}

+ (CPDictionary)parseLine:(CPString)lineData withContext:(CPDictionary)context delegate:(UITestScript)delegate
{
	try
	{
		if(lineData.match(/When.*/))
		{
			return parseWhenExpression(lineData, context, delegate);
		}
		else if(lineData.match(/Is.*/))
		{
			return parseActionExpression(lineData, context, delegate);
		}
		else if(lineData.match(/Then.*/))
		{
			return parseThenExpression(lineData, context, delegate);
		}
		else if(lineData.match(/Should.*/) || lineData.match(/And.*/))
		{
			return parseResponseExpression(lineData, context, delegate);
		}
		else
		{
			return parseError(lineData, context, delegate);
		}
	}
	catch(ex)
	{
		return parseError(lineData, context, delegate);
	}
}

@end

function parseError(lineData, context, delegate)
{
	return function()
	{
		[delegate addError:"Was unable to parse the line " + lineData];
	}
}

function parseWhenExpression(lineData, context, delegate)
{
	if(lineData.match(/When view with tag (.+)/))
	{
		return function()
		{
			var tagValue = lineData.match(/When view with tag (.+)/)[1];
			var aView = findView(eval('("'+tagValue+'")'));
			if(aView)
			{
				[context setObject:aView forKey:@"when"];
			}
			else
			{
				parseError(lineData, context, delegate);
			}
		};
	}
	else
	{
		return parseError(lineData, context, delegate);
	}
}

function parseActionExpression(lineData, context, delegate)
{
	if(lineData.match(/Is (.+)/))
	{
		var action = lineData.match(/Is (.+)\s*(.*)/)[1];
		var arg = lineData.match(/Is (.+)\s*(.*)/)[2];
		var className = "UIAction" + action;
		var actionParser = objj_getClass(className);
		return [actionParser parse:arg context:context delegate:delegate];
	}
	else
	{
		return parseError(lineData, context, delegate);
	}
}

function parseThenExpression(lineData, context, delegate)
{
	if(lineData.match(/Then view with tag (.+)/))
	{
		return function()
		{
			var tagValue = lineData.match(/Then view with tag (.+)/)[1];
			var aView = findView(eval('("'+tagValue+'")'));
			if(aView)
			{
				[context setObject:aView forKey:@"then"];
			}
			else
			{
				parseError(lineData, context, delegate);
			}
		};
	}
	else
	{
		return parseError(lineData, context, delegate);
	}
}

function parseResponseExpression(lineData, context, delegate)
{
	if(lineData.match(/Should (.+)/))
	{
		var response = lineData.match(/Should (.+?)(\s|$)(.*)/)[1];
		var arg = lineData.match(/Should (.+?)(\s|$)(.*)/)[3];
		var className = "UIResponse" + response;
		var responseParser = objj_getClass(className);
		return [responseParser parse:arg context:context delegate:delegate];
	}
	else if(lineData.match(/And (.+)/))
	{
		var response = lineData.match(/And (.+?)(\s|$)(.*)/)[1];
		var arg = lineData.match(/And (.+?)(\s|$)(.*)/)[2];
		var className = "UIResponse" + response;
		var responseParser = objj_getClass(className);
		return [responseParser parse:arg context:context delegate:delegate];
	}
	else
	{
		return parseError(lineData, context, delegate);
	}
}

function findView(tagValue)
{
	var windows = [CPApp windows];
	
	for(var i = 0; i < [windows count]; i++)
	{
		if(windows[i])
		{
			var aView = findViewHelper(tagValue, [[windows objectAtIndex:i] contentView]);
			if(aView)
			{
				return aView;
			}
		}
	}
	
	return nil;
}

function findViewHelper(tagValue, viewToSearch)
{
	var views = [viewToSearch subviews];
	if(views)
	{
		for(var i = 0; i < [views count]; i++)
		{
			var aView = [views objectAtIndex:i];
			if([aView tag] == tagValue)
			{
				return aView;
			}
			
			var aChildView = findViewHelper(tagValue, aView);
			
			if(aChildView)
			{
				return aChildView;
			}
		}
	}
	
	return nil;
}
