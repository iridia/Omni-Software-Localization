@import "DataController.j"

@implementation GitHubWikiController : DataController
{
	CPArray connections;
}
	
- (id)initWithPages:(CPArray)somePages
{
	self = [super init];
	
	if (self)
	{
		connections = [];
		
		var baseUrl = [[CPURL alloc] initWithString:@"http://wiki.github.com/hammerdr/Omni-Software-Localization/"];
		
		for (var i=0; i < [somePages count]; i++)
		{
			var url = [[CPURL alloc] initWithString:baseUrl + [[somePages objectAtIndex:i] path]];
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
	
	var nextMatch = regEx.exec(data);
	
	var allMatches = [[CPArray init] alloc];
	[allMatches addObject:nextMatch];
	
	while (nextMatch)
	{
		[allMatches addObject:nextMatch];
		nextMatch = regEx.exec(data);
	}
	console.log([allMatches count]);
	console.log(allMatches);
	
	var goodMatches = [[CPArray init] alloc];
	
	for (var i=0; i<[allMatches count]; i++)
	{
		var match = [[allMatches objectAtIndex:i] objectAtIndex:1];
		if (match.indexOf("</del>") < 0)
		{
			[goodMatches addObject:match];
		}
	}
	
	console.log(goodMatches);
	
//	var commits = data.commits;
//	
//	for (var j = 0; j < [[self users] count]; j++) {
//		var user = [[self users] objectAtIndex:j];
//		var gitHubHandle = [[user handles] objectForKey:[self key]];
//		
//		for (var i = 0; i < commits.length; i++) {
//			var commit = commits[i];
//			if (commit.author.name === gitHubHandle) {
//				var message = [commit.message removeTime];
//				
//				var time = [commit.message findTime];
//				
//				var date = [commit.authored_date convertFromGitHubDateToCPDate];
//				
//				var link = [CPURL URLWithString:commit.url];
//				
//				[user addData:[[UserData alloc] initWithMessage:message time:time date:date source:@"GitHub" user:[user name] link:link]];
//			}
//		}
//	}

}

@end