@import <Foundation/CPObject.j>
@import "../Views/OLMenu.j"

OLMenuItemEnabled = YES;
OLMenuItemDisabled = NO;

@implementation OLMenuController : CPObject
{
    CPMenu                      menu;
    CPUploadWindowController    uploadWindowController  @accessors;
    CPDictionary                items;
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
        
        items = [CPDictionary dictionary];
        
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemNew];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemSave];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemNewLanguage];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemDeleteLanguage];
        
        menu = [[OLMenu alloc] initWithTitle:@"Omni Software Localization" controller:self];
        [[CPApplication sharedApplication] setMainMenu:menu];
    }
    return self;
}

- (CPDictionary)items
{
    return [CPDictionary dictionaryWithDictionary:items];
}

- (void)enableItems:(CPNotification)aNotification
{
    var array = [aNotification object];
    
    for(var i = 0; i < [array count]; i++)
    {
        var key = [array objectAtIndex:i];
        [items setObject:OLMenuItemEnabled forKey:key];
    }
}

- (void)disableItems:(CPNotification)aNotification
{
    var array = [aNotification object];
    
    for(var i = 0; i < [array count]; i++)
    {
        var key = [array objectAtIndex:i];
        [items setObject:OLMenuItemDisabled forKey:key];
    }
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

@end
