@import <Foundation/CPObject.j>

@implementation ActionItem : CPObject
{
    CPString actionItem @accessors(readonly);
}

- (id)initWithString:(CPString)newActionItem
{
    self = [super init];
    
    if (self)
    {
        actionItem = newActionItem;
    }
    
    return self;
}

@end