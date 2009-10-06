@import <Foundation/CPObject.j>
@import "../Users/EJUserData.j"

@implementation EJAbstractSourceController : CPObject
{
    CPString _key @accessors(property=key, readonly);
    EJUser _currentUser @accessors(property=currentUser);
    CPArray _currentUserData @accessors(property=currentUserData);
}

- (id)initWithKey:(CPString)aKey
{
    self = [super init];
    
    if (self)
    {
        _key = aKey;
        _currentUser = nil;
        _currentUserData = [];
    }
    
    return self;
}

- (void)insertObject:(id)anObject inCurrentUserDataAtIndex:(CPInteger)anIndex
{
    [[self currentUserData] insertObject:anObject atIndex:anIndex];
}

- (BOOL)currentUserHasSource
{
    if (!_currentUser)
        return NO;
    
    return ([[_currentUser handles] objectForKey:_key] != nil)
}

- (void)fetchDataForCurrentUser
{
    console.warn("You should override me.");
}

- (void)connection:(CPJSONPConnection)connection didReceiveData:(CPString)data
{
    console.warn("You should really override me.");
}

- (void)connection:(CPJSONPConnection)connection didFailWithError:(CPString)error
{
    console.error("An error occurred for the connection", connection, "on class", class_getName(self), ":", error);
}

@end