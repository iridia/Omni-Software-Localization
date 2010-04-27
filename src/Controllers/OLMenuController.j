@import <Foundation/CPObject.j>
@import "../Views/OLMenu.j"
@import "OLMyProjectController.j"
@import "OLUploadWindowController.j"
@import "../Utilities/OLConstants.j"

OLMenuItemEnabled = YES;
OLMenuItemDisabled = NO;

@implementation OLMenuController : CPObject
{
    CPMenu                      menu;
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
            name:OLMenuShouldEnableItemsNotification
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(disableItems:)
            name:OLMenuShouldDisableItemsNotification
            object:nil];
        
        items = [CPDictionary dictionary];
        
        [items setObject:OLMenuItemEnabled forKey:OLMenuItemNew];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemSave];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemNewLanguage];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemDeleteLanguage];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemImport];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemDownload];
        
        menu = [[OLMenu alloc] initWithTitle:@"OLMainMenu" controller:self];
        [[CPApplication sharedApplication] setMainMenu:menu];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
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
    
    [menu reloadState:self];
}

- (void)disableItems:(CPNotification)aNotification
{
    var array = [aNotification object];
    
    for(var i = 0; i < [array count]; i++)
    {
        var key = [array objectAtIndex:i];
        [items setObject:OLMenuItemDisabled forKey:key];
    }
    
    [menu reloadState:self];
}

- (void)newLanguage:(id)sender
{
    [self _postNotification:OLProjectShouldCreateBundleNotification];
}

- (void)deleteLanguage:(id)sender
{
    [self _postNotification:OLProjectShouldDeleteBundleNotification];
}

- (void)about:(id)sender
{
    alert = [[CPAlert alloc] init];
    [alert setTitle:[CPString stringWithFormat:@"About %s", [[CPBundle mainBundle] objectForInfoDictionaryKey:@"CPBundleName"]]];
    [alert setAlertStyle:CPInformationalAlertStyle];
    [alert setMessageText:@"Created by Derek Hammer, Chandler Kent and Kyle Rhodes."];
    [alert addButtonWithTitle:@"Close"];
    [alert runModal];
}

- (void)new:(id)sender
{
    [self _postNotification:OLUploadWindowShouldStartUploadNotification];
}

- (void)download:(id)sender
{
    [self _postNotification:OLProjectShouldDownloadNotification];
}

- (void)importItem:(id)sender
{
    [self _postNotification:OLProjectShouldImportNotification];
}

- (void)feedback:(id)sender
{
    [self _postNotification:OLFeedbackControllerShouldShowWindowNotification];
}

- (void)login:(id)sender
{
    [self _postNotification:OLLoginControllerShouldLoginNotification];
}

- (void)logout:(id)sender
{
    [self _postNotification:OLLoginControllerShouldLogoutNotification];
}

- (void)sendMessage:(id)sender
{
    [self _postNotification:OLMessageControllerShouldCreateMessageNotification];
}

- (void)broadcastMessage:(id)sender
{
    [self _postNotification:OLProjectShouldBroadcastMessage];
}

- (void)undo:(id)sender
{
    [OLUndoManager undo];
}

- (void)redo:(id)sender
{
    [OLUndoManager redo];
}

- (void)_postNotification:(CPString)notificationName
{
    [[CPNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

@end
