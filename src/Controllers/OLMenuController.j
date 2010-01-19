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
            
        menu = [[OLMenu alloc] initWithTitle:@"Omni Software Localization" controller:self];
        [[CPApplication sharedApplication] setMainMenu:menu];
    }
    return self;
}

- (void)enableItems:(CPNotification)aNotification
{
    
}

- (void)disableItems:(CPNotification)aNotification
{
    
}

- (void)newLanguage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPLanguageShouldAddLanguageNotification" object:self];
}

- (void)deleteLanguage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPLanguageShouldDeleteLanguageNotification" object:self];
}

- (void)about:(id)sender
{
    alert = [[CPAlert alloc] init];
    [alert setTitle:@"About Omni Software Localization"];
    [alert setAlertStyle:CPInformationalAlertStyle];
    [alert setMessageText:@"Created by Derek Hammer, Chandler Kent and Kyle Rhodes."];
    [alert addButtonWithTitle:@"Close"];
    [alert runModal];
}

- (void)new:(id)sender
{
    [uploadWindowController startUpload:self];
}

- (void)quit:(id)sender
{
    // TODO: Make the app quit
}

@end
