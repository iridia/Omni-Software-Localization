@import <Foundation/CPObject.j>
@import "UserData.j"

@implementation DataController : CPObject
{
    CPArray users @accessors;
    CPString key @accessors;
}

- (id)initWithUsers:(CPArray)someUsers andKey:(CPString)aKey
{
    self = [super init];
    
    if (self)
    {
        users = someUsers;
        key = aKey;
    }
    
    return self;
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPString)data
{
    console.warn("You should really override me.");
}

- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.error(error);
}

@end