@import "EJAbstractSourceController.j"

@implementation EJRSSController : EJAbstractSourceController
{
    CPArray connections;
}

- (void)fetchDataForCurrentUser
{
    if (![self currentUserHasSource])
        return;

    console.log("getting data for", _key, _currentUser);

    var url = [[CPURL alloc] initWithString:[[_currentUser handles] objectForKey:_key]];
    var request = [CPURLRequest requestWithURL:url];
    var connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{
	var user = [self currentUser];
    var posts = data.items;
    
    for (var i = 0; i < [posts count]; i++)
    {
        var post = [posts objectAtIndex:i];
        
        var message = post.title;
        var link = [CPURL URLWithString:post.link];
        var date = [[CPDate alloc] initWithString:post.date];
        var dictionary = [[CPDictionary alloc] initWithObjects:[message, 0, date, link, @"Blog", [user displayName]]
                                                       forKeys:[@"message", @"time", @"date", @"link", @"source", @"user"]];
        
        var data = [[EJUserData alloc] initWithDictionary:dictionary];
        [user addData:data];
        [self insertObject:data inCurrentUserDataAtIndex:i];
    }
}

@end