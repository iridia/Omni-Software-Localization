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
            if (commits[i].author.name === gitHubHandle) {
                var text = commits[i].message;
                var time = 100;

                [user addData:[[UserData alloc] initWithText:text andTime:time]];
            }
        }
    }
}

@end