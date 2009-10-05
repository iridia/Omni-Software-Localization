@import <Foundation/CPObject.j>
@import "EJUserData.j"

@implementation EJUser : CPObject
{
    CPDictionary    handles @accessors(readonly);
    CPString        displayName @accessors(readonly);
    CPArray         data @accessors(readonly);
}

- (id)initWithDictionary:(CPDictionary)aDictionary
{
    self = [super init];
    
    if (self)
    {
        data = [];
        handles = [aDictionary objectForKey:@"Handles"];
        displayName = [aDictionary objectForKey:@"Display Name"];
    }
    
    return self;
}

- (void)addData:(UserData)moreData
{
    [data addObject:moreData];
}

- (CPComparisonResult)compare:(EJUser)otherUser
{
    if ([self displayName] < [otherUser displayName])
        return CPOrderedAscending;
    else
        return CPOrderedDescending;
}

@end