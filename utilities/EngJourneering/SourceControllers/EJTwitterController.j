@import "EJAbstractSourceController.j"

var ProjectOSL = "projectosl";

@implementation EJTwitterController : EJAbstractSourceController
{
    CPArray connections;
}

- (id)initWithUsers:(CPArray)someUsers andKey:(CPString)aKey
{
    self = [super initWithUsers:someUsers andKey:aKey];
    
    if (self)
    {
        connections = [];
        
        for (var i = 0; i < [users count]; i++) {
            var url = [[CPURL alloc] initWithString:@"http://twitter.com/status/user_timeline/" + [[users[i] handles] objectForKey:[self key]] + ".json"];
            var request = [CPURLRequest requestWithURL:url];
            var connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
            [connections addObject:connection];
        }
    }
    
    return self;
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)tweets
{
    var user = [[self users] objectAtIndex:[connections indexOfObject:connection]];
    
    for (var i = 0; i < tweets.length; i++) {
        var tweet = [tweets objectAtIndex:i];
        if ((tweet.in_reply_to_screen_name === ProjectOSL) || (tweet.text.indexOf(ProjectOSL) >= 0)) {
            var message = [[tweet.text removeOccurencesOfString:"@" + ProjectOSL] removeTime];
            var time = [tweet.text findTime];
            var date = [[CPDate alloc] initWithString:tweet.created_at];
            var link = [CPURL URLWithString:@"http://www.twitter.com/" + [[user handles] objectForKey:[self key]] + "/status/" + tweet.id];
            
            var dictionary = [[CPDictionary alloc] initWithObjects:[message, time, date, link, @"Twitter", [user displayName]]
                                                           forKeys:[@"message", @"time", @"date", @"link", @"source", @"user"]];
            [user addData:[[EJUserData alloc] initWithDictionary:dictionary]];
        }
    }
}

@end