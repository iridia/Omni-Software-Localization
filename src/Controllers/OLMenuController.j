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
            selector:@selector(test:)
            name:@"OLMenuShouldEnableItemsNotification"
            object:nil];
    }
    return self;
}

@end
