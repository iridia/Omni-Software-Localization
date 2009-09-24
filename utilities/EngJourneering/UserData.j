@import <Foundation/CPObject.j>

@implementation UserData : CPObject
{
    CPString text @accessors(readonly);
    CPNumber time @accessors(readonly);
}

- (id)initWithText:(CPString)aText andTime:(CPNumber)aTime
{
    self = [super init];
    
    if (self)
    {
        text = aText;
        time = aTime;
    }
    
    return self;
}

@end