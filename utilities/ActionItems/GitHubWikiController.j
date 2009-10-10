@import "DataController.j"
@import "ActionItem.j"

@implementation GitHubWikiController : DataController
{
	CPArray connections;
}
	
- (id)initWithPages:(CPArray)somePages
{
	self = [super initWithPages:somePages];
	
	if (self)
	{
		connections = [];
		
		var baseUrl = [[CPURL alloc] initWithString:@"http://wiki.github.com/hammerdr/Omni-Software-Localization/"];
		
		for (var i=0; i < [pages count]; i++)
		{
			var url = [[CPURL alloc] initWithString:baseUrl + [[pages objectAtIndex:i] path]];
			var request = [CPURLRequest requestWithURL:url];
			var connection = [CPURLConnection connectionWithRequest:request delegate:self];
			[connections addObject:connection];
		}
	}
	
	return self;
}





- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{	
	var regEx = new RegExp(".*<b>Action Item<\\/b>(.*)<\\/(li|td|p)>", "gi");
	
	var page = [pages objectAtIndex:[connections indexOfObject:connection]];
	
	var nextMatch = regEx.exec(data);
	
	var allMatches = [[CPArray init] alloc];
	
	while (nextMatch)
	{
		[allMatches addObject:nextMatch];
		nextMatch = regEx.exec(data);
	}
	
	// var completedMatches = [[CPArray init] alloc]; // delete later
	
	for (var i=0; i<[allMatches count]; i++)
	{
		var match = [[allMatches objectAtIndex:i] objectAtIndex:1];

		if (match.indexOf("</del>") < 0)
		{
			[page addActionItem:[[ActionItem alloc] initWithString:match]];
		}
	//	else [completedMatches addObject:match]; // TODO: Add completed matches
	}
	
	console.log("GOOD MATCHES: ", page);
	//console.log("COMPLETED MATCHES: " + completedMatches);
	


}

@end