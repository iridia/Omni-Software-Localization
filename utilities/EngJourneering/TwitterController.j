@import "DataController.j"

var ProjectOSL = "projectosl";
var timeRegEx = new RegExp(".*t:(\d+)h(\d+)m", "i");

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
    var pos = [connections indexOfObject:connection];
    var user = [[self users] objectAtIndex:pos];

    for (var i = 0; i < data.length; i++) {
        if (data[i].in_reply_to_screen_name === ProjectOSL) {
            var text = data[i].text;
            //var matches = timeRegEx.exec(text);
//            var hours = 60 * matches[0];
//            var minutes = matches[1];
            //var time = hours + minutes;
            
            [user addData:[[UserData alloc] initWithText:text andTime:100]];
        }
    }
}


- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.log("Twitter Error!!!");
    console.error(error);
}

@end