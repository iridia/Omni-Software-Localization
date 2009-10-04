@import "DataController.j"

@implementation GitHubWikiController : DataController
{
	CPJSONPConnection connection;
}
	
- (id)init
{
	self = [super init];
	
	if (self)
	{
		var url = [[CPURL alloc] initWithString:@"http://wiki.github.com/hammerdr/Omni-Software-Localization/"];
	}
	
	return self;
}





- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{

	console.log(data);

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