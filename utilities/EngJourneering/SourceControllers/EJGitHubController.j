@import "EJAbstractSourceController.j"

@implementation EJGitHubController : EJAbstractSourceController
{
    CPURL _gitHubURL;
}

- (id)initWithKey:(CPString)key
{
    self = [super initWithKey:key];
    
    if (self)
    {
        _gitHubURL = [[CPURL alloc] initWithString:@"http://github.com/api/v2/json/commits/list/hammerdr/Omni-Software-Localization/master"];
    }
    
    return self;
}

- (void)fetchDataForCurrentUser
{
    if (![self currentUserHasSource])
        return;

    console.log("getting data for", _key, _currentUser);
    var request = [CPURLRequest requestWithURL:_gitHubURL];
    var connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{
    var commits = data.commits;
    var user = [self currentUser];
    var gitHubHandle = [[user handles] objectForKey:[self key]];
    
    for (var i = 0; i < commits.length; i++) {
        var commit = commits[i];
        if (commit.author.name === gitHubHandle) {
            var message = [commit.message removeTime];
            var time = [commit.message findTime];
            var date = [commit.authored_date convertFromGitHubDateToCPDate];
            var link = [CPURL URLWithString:commit.url];
            
            var dictionary = [[CPDictionary alloc] initWithObjects:[message, time, date, link, @"Github", [user displayName]]
                                                           forKeys:[@"message", @"time", @"date", @"link", @"source", @"user"]];
            
            var data = [[EJUserData alloc] initWithDictionary:dictionary];
            [user addData:data];
            [self insertObject:data inCurrentUserDataAtIndex:i];
        }
    }
}

@end