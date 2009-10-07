@import <Foundation/CPObject.j>
@import "EJUserData.j"

@implementation EJUser : CPObject
{
    CPDictionary    _handles @accessors(property=handles, readonly);
    CPString        _displayName @accessors(property=displayName, readonly);
    CPArray         _data @accessors(property=data);
}

- (id)initWithDictionary:(CPDictionary)aDictionary
{
    self = [super init];
    
    if (self)
    {
        _data = [];
        _handles = [aDictionary objectForKey:@"Handles"];
        _displayName = [aDictionary objectForKey:@"Display Name"];
    }
    
    return self;
}

- (void)insertObject:(UserData)data inDataAtIndex:(CPInteger)index
{
    // console.log("inserting", [data message], "for user", _displayName);
    [_data insertObject:data atIndex:index];
}

- (CPComparisonResult)compare:(EJUser)otherUser
{
    if ([self displayName] < [otherUser displayName])
        return CPOrderedAscending;
    else
        return CPOrderedDescending;
}

@end