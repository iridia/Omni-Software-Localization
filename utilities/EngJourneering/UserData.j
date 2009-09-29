@import <Foundation/CPObject.j>

@implementation UserData : CPObject
{
    CPString message @accessors(readonly);
    CPNumber time @accessors(readonly);
    CPDate date @accessors(readonly);
    CPString source @accessors(readonly);
    CPString user @accessors(readonly);
    CPURL link @accessors(readonly);
}

- (id)initWithMessage:(CPString)aMessage time:(CPNumber)aTime date:(CPDate)aDate source:(CPString)theSource user:(CPString)theUser link:(CPURL)aLink
{
    self = [super init];
    
    if (self)
    {
        message = aMessage;
        time = aTime;
        date = aDate;
        source = theSource;
        user = theUser;
        link = aLink;
    }
    
    return self;
}

- (unsigned)compare:(UserData)other
{
    if ([self date] < [other date])
    {
        return CPOrderedDescending;
    } else if ([self date] > [other date]) {
        return CPOrderedAscending;
    } else {
        return CPOrderedSame;
    }
}

@end