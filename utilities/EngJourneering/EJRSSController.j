@import "EJSourceController.j"

@implementation EJRSSController : EJSourceController
{
    CPArrays connections;
}

- (id)initWithUsers:(CPArray)someUsers andKey:(CPString)aKey
{
    self = [super initWithUsers:someUsers andKey:aKey];
    
    if (self)
    {
        connections = [];
        
        for (var i = 0; i < [users count]; i++) {
            var user = [users objectAtIndex:i];
            var url = [[CPURL alloc] initWithString:[[user handles] objectForKey:key]];
            var request = [CPURLRequest requestWithURL:url];
            var connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
            [connections addObject:connection];
        }
    }
    
    return self;
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{
	var user = [users objectAtIndex:[connections indexOfObject:connection]];
    var posts = data.items;
    
    for (var i = 0; i < [posts count]; i++)
    {
        var post = [posts objectAtIndex:i];
        var link = [CPURL URLWithString:post.link];
        var date = [[CPDate alloc] initWithString:post.date];
        
        var dictionary = [[CPDictionary alloc] initWithObjects:[post, 0, date, link, @"Blog", [user displayName]]
                                                       forKeys:[@"message", @"time", @"date", @"link", @"source", @"user"]];
        [user addData:[[EJUserData alloc] initWithDictionary:dictionary]];
    }
}


- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.log("JSON Blog Reading Error!!!");
    console.error(error);
}

@end