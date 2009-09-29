@import "DataController.j"

var ProjectOSL = "projectosl";

@implementation TwitterController : DataController
{
    CPArray connections;
}

- (id)initWithUsers:(CPArray)someUsers andKey:(CPString)aKey
{
    self = [super initWithUsers:someUsers andKey:aKey];
    
    if (self)
    {
        connections = [];
        
        for (var i = 0; i < users.length; i++) {
            var url = [[CPURL alloc] initWithString:@"http://twitter.com/status/user_timeline/" + [[users[i] handles] objectForKey:[self key]] + ".json"];
            var request = [CPURLRequest requestWithURL:url];
            var connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
            [connections addObject:connection];
        }
    }
    
    return self;
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{
    var user = [[self users] objectAtIndex:[connections indexOfObject:connection]];
    
    for (var i = 0; i < data.length; i++) {
        if (data[i].in_reply_to_screen_name === ProjectOSL) {
            var message = [data[i].text removeOccurencesOfString:"@" + ProjectOSL]
            
            var time = [message findTimeInString];
            
            var date = [[CPDate alloc] initWithString:data[i].created_at];
            
            var link = [CPURL URLWithString:@"http://www.twitter.com/" + [[user handles] objectForKey:[self key]] + "/status/" + data[i].id];
            
            [user addData:[[UserData alloc] initWithMessage:message time:time date:date source:@"Twitter" user:[user name] link:link]];
        }
    }
}


- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.log("Twitter Error!!!");
    console.error(error);
}

@end