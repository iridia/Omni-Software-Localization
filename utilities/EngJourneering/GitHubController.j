@import "DataController.j"

@implementation GitHubController : DataController
{
    CPJSONPConnection connection;
}

- (id)initWithUsers:(CPArray)someUsers andKey:(CPString)aKey
{
    self = [super initWithUsers:someUsers andKey:aKey];
    
    if (self)
    {
        var url = [[CPURL alloc] initWithString:@"http://github.com/api/v2/json/commits/list/hammerdr/Omni-Software-Localization/master"];
        var request = [CPURLRequest requestWithURL:url];
        connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
    }
    
    return self;
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{
    var commits = data.commits;
    
    for (var j = 0; j < [[self users] count]; j++) {
        var user = [[self users] objectAtIndex:j];
        var gitHubHandle = [[user handles] objectForKey:[self key]];
        
        for (var i = 0; i < commits.length; i++) {
            var commit = commits[i];
            if (commit.author.name === gitHubHandle) {
                var message = [commit.message removeTime];
                
                var time = [commit.message findTime];
                
                var date = [commit.authored_date convertFromGitHubDateToCPDate];
                
                var link = [CPURL URLWithString:commit.url];
                
                [user addData:[[UserData alloc] initWithMessage:message time:time date:date source:@"GitHub" user:[user name] link:link]];
            }
        }
    }
}

@end