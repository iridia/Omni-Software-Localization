@import <Foundation/CPObject.j>
@import "../Views/OLMenu.j"

OLMenuItemEnabled = YES;
OLMenuItemDisabled = NO;

@implementation OLMenuController : CPObject
{
    CPMenu                      menu;
    CPUploadWindowController    uploadWindowController  @accessors;
    CPDictionary                items;
    CPFeedbackController        feedbackController;
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
        
        [items setObject:OLMenuItemEnabled forKey:OLMenuItemNew];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemSave];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemNewLanguage];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemDeleteLanguage];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemImport];
        [items setObject:OLMenuItemDisabled forKey:OLMenuItemDownload];
        
        menu = [[OLMenu alloc] initWithTitle:@"OLMainMenu" controller:self];
        [[CPApplication sharedApplication] setMainMenu:menu];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
        feedbackController = [[OLFeedbackController alloc] init];
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
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPLanguageShouldAddLanguageNotification" object:self];
}

- (void)deleteLanguage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPLanguageShouldDeleteLanguageNotification" object:self];
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
    [uploadWindowController startUpload:self];
}

- (void)download:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"OLProjectShouldDownloadNotification" object:self];
}

- (void)importItem:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"OLProjectShouldImportNotification" object:self];
}

- (void)undo:(id)sender
{
    [OLUndoManager undo];
}

- (void)redo:(id)sender
{
    [OLUndoManager redo];
}

- (void)feedback:(id)sender
{
    [feedbackController showFeedbackWindow:sender];
}

- (void)login:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLoginControllerShouldLoginNotification
        object:self];    
}

- (void)sendMessage:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLMessageControllerShouldCreateMessageNotification
        object:self];
}

- (void)broadcastMessage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPMessageShouldBroadcastNotification" object:self];
}

@end
