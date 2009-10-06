@import "UserData.j"

@implementation RssController : CPObject
{
	User user @accessors;
}

- (id)initWithFeed:(CPString)aFeed andUser:(User)aUser
{
    self = [super init];
    
    if (self)
    {
    	user = aUser;
    	
        var request = [CPURLRequest requestWithURL:aFeed];
        var connection = [CPJSONPConnection sendRequest:request callback:@"callback" delegate:self];
    }
    
    return self;
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPJSObject)data
{
	var posts = data.items;
	
	for (var i = posts.length - 1; i >= 0; i--) 
	{
		[user addData:[self _getUserDataFromPost:posts[i]]];
	};
}


- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.log("JSON Blog Reading Error!!!");
    console.error(error);
}


//@private
- (UserData)_getUserDataFromPost:(CPJSObject)post
{
	console.log(post.link);
	
	var link = [CPURL URLWithString:post.link];
	var date = [[CPDate alloc] initWithString:post.date];
	
	return [[UserData alloc] initWithMessage:post.title time:0 date:date source:@"Blog" user:[user name] link:link]; 
}

@end