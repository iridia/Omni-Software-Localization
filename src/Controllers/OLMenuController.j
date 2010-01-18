@import <Foundation/CPObject.j>
@import "../Views/OLMenu.j"

@implementation OLMenuController : CPObject
{
    CPMenu      menu;
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
            
        menu = [[OLMenu alloc] init];
        [[CPApplication sharedApplication] setMainMenu:menu];
    }
    return self;
}

@end
