@import <Foundation/CPObject.j>
@import "../EJUserData.j"

@implementation EJSourceController : CPObject
{
    CPArray users @accessors(readonly);
    CPString key @accessors(readonly);
}

- (id)initWithUsers:(CPArray)someUsers andKey:(CPString)aKey
{
    self = [super init];
    
    if (self)
    {
        key = aKey;
        users = [];
        for (var i = 0; i < [someUsers count]; i++)
        {
            var user = [someUsers objectAtIndex:i];
            if ([[user handles] objectForKey:key] != nil)
            {
                [users addObject:user];
            } else {
                console.log("user", [user displayName], "doesn't have a", key);
            }
        }
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