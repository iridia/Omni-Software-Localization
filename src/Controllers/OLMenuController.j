@import <Foundation/CPObject.j>

@implementation OLMenuController : CPObject
{
}

- (id)init
{
    self = [super init];
    if(self)
    {
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(enableItems:)
            name:@"OLMenuShouldEnableItemsNotification"
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(disableItems:)
            name:@"OLMenuShouldDisableItemsNotification"
            object:nil];
    }
    return self;
}

@end
