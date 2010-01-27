@import <AppKit/CPMenu.j>

@import "../Controllers/OLFeedbackController.j"
@import "../Controllers/OLLoginController.j"
@import "../Controllers/OLUploadWindowController.j"

OLMenuItemNew = @"OLMenuItemNew";
OLMenuItemSave = @"OLMenuItemSave";
OLMenuItemNewLanguage = @"OLMenuItemNewLanguage";
OLMenuItemDeleteLanguage = @"OLMenuItemDeleteLanguage";
OLMenuItemImport = @"OLMenuItemImport";
OLMenuItemDownload = @"OLMenuItemDownload";

@implementation OLMenu : CPMenu
{
    CPMenuItem newItem;
    CPMenuItem saveItem;
    CPMenuItem newLanguage;
    CPMenuItem deleteLanguage;
}

- (id)initWithTitle:(CPString)title
{
    [self initWithTitle:title controller:nil];
}

- (id)initWithTitle:(CPString)title controller:(OLMenuController)controller
{
    self = [super initWithTitle:title];
    
    if (self)
    {
<<<<<<< HEAD
        var appMenu = [[CPMenuItem alloc] initWithTitle:@"Omni Software Localization" action:nil keyEquivalent:nil];
        var appSubmenu = [[CPMenu alloc] initWithTitle:@"AppMenu"];
        var aboutItem = [[CPMenuItem alloc] initWithTitle:@"About Omni Software Localization" action:@selector(about:) keyEquivalent:nil];
        var quitItem = [[CPMenuItem alloc] initWithTitle:@"Quit Omni Software Localization" action:@selector(quit:) keyEquivalent:"q"];
        
        [aboutItem setTarget:self];
        [quitItem setTarget:self];
        [appSubmenu addItem:aboutItem];
        [appSubmenu addItem:quitItem];
        [appMenu setSubmenu:appSubmenu];
        
        var fileMenu = [[CPMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:nil];
        var fileSubmenu = [[CPMenu alloc] initWithTitle:@"FileMenu"];
        var newItem = [[CPMenuItem alloc] initWithTitle:@"New..." action:@selector(new:) keyEquivalent:"n"];
        var saveItem = [[CPMenuItem alloc] initWithTitle:@"Save" action:@selector(save:) keyEquivalent:"s"];
        
        [fileSubmenu addItem:newItem];
        [fileSubmenu addItem:saveItem];
        
        [newItem setTarget:self];
        [fileMenu setSubmenu:fileSubmenu];
        
        var projectMenu = [[CPMenuItem alloc] initWithTitle:@"Project" action:nil keyEquivalent:nil];
        var projectSubmenu = [[CPMenu alloc] initWithTitle:@"ProjectMenu"];
        var newLanguage = [[CPMenuItem alloc] initWithTitle:@"New Language.." action:@selector(newLanguage:) keyEquivalent:nil];
        var deleteLanguage = [[CPMenuItem alloc] initWithTitle:@"Delete Language.." action:@selector(deleteLanguage:) keyEquivalent:nil];
        var broadcastMessage = [[CPMenuItem alloc] initWithTitle:@"New Broadcast.." action:@selector(broadcastMessage:) keyEquivalent:"b"];
        [broadcastMessage setKeyEquivalentModifierMask:CPShiftKeyMask | CPCommandKeyMask];
        
        [projectMenu setSubmenu:projectSubmenu];
        [projectSubmenu addItem:newLanguage];
        [projectSubmenu addItem:deleteLanguage];
        [projectSubmenu addItem:broadcastMessage];
        
        [newLanguage setTarget:self];
        [deleteLanguage setTarget:self];
        [broadcastMessage setTarget:self];
        
        [self addItem:appMenu];
        [self addItem:fileMenu];
        [self addItem:projectMenu];
        [self addItem:[CPMenuItem separatorItem]];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
=======
        [self reloadState:controller];
>>>>>>> 2fd7ed3c484c75b883e2397ba0d0b1842d310a87
    }
    
    return self;
}

<<<<<<< HEAD
- (void)newLanguage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPLanguageShouldAddLanguageNotification" object:self];
}

- (void)deleteLanguage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPLanguageShouldDeleteLanguageNotification" object:self];
}

- (void)broadcastMessage:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"CPMessageShouldBroadcastNotification" object:self];
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

- (void)updateLoginItemWithTitle:(CPString)aTitle
=======
- (void)reloadState:(OLMenuController)controller
>>>>>>> 2fd7ed3c484c75b883e2397ba0d0b1842d310a87
{
    for(var i = [self numberOfItems]-1; i >= 0; i--)
    {
        [self removeItemAtIndex:i];
    }
    
    var appMenu = [[CPMenuItem alloc] initWithTitle:@"Omni Software Localization" action:nil keyEquivalent:nil];
    var appSubmenu = [[CPMenu alloc] initWithTitle:@"AppMenu"];
    var aboutItem = [[CPMenuItem alloc] initWithTitle:@"About Omni Software Localization" action:@selector(about:) keyEquivalent:nil];
    
    
    var fileMenu = [[CPMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:nil];
    var fileSubmenu = [[CPMenu alloc] initWithTitle:@"FileMenu"];
    var newItem = [[CPMenuItem alloc] initWithTitle:@"New..." action:@selector(new:) keyEquivalent:"n"];
    var saveItem = [[CPMenuItem alloc] initWithTitle:@"Save" action:@selector(save:) keyEquivalent:"s"];
    
    
    var projectMenu = [[CPMenuItem alloc] initWithTitle:@"Project" action:nil keyEquivalent:nil];
    var projectSubmenu = [[CPMenu alloc] initWithTitle:@"ProjectMenu"];
    var newLanguage = [[CPMenuItem alloc] initWithTitle:@"New Language.." action:@selector(newLanguage:) keyEquivalent:nil];
    var deleteLanguage = [[CPMenuItem alloc] initWithTitle:@"Delete Language.." action:@selector(deleteLanguage:) keyEquivalent:nil];
    var download = [[CPMenuItem alloc] initWithTitle:@"Download" action:@selector(download:) keyEquivalent:"d"];
    var importItem = [[CPMenuItem alloc] initWithTitle:@"Import..." action:@selector(importItem:) keyEquivalent:"i"];
    
    [newLanguage setTarget:controller];
    [deleteLanguage setTarget:controller];
    [aboutItem setTarget:controller];
    [newItem setTarget:controller];
    [download setTarget:controller];
    [importItem setTarget:controller];
    
    var items = [controller items];

    [newItem setEnabled:[items objectForKey:OLMenuItemNew]];
    [saveItem setEnabled:[items objectForKey:OLMenuItemSave]];
    [newLanguage setEnabled:[items objectForKey:OLMenuItemNewLanguage]];
    [deleteLanguage setEnabled:[items objectForKey:OLMenuItemDeleteLanguage]];
    [download setEnabled:[items objectForKey:OLMenuItemDownload]];
    [importItem setEnabled:[items objectForKey:OLMenuItemImport]];
    
    [fileSubmenu addItem:newItem];
    [fileSubmenu addItem:saveItem];
    
    [fileMenu setSubmenu:fileSubmenu];
    
    [appSubmenu addItem:aboutItem];
    [appMenu setSubmenu:appSubmenu];
    
    [projectMenu setSubmenu:projectSubmenu];
    [projectSubmenu addItem:newLanguage];
    [projectSubmenu addItem:deleteLanguage];
    [projectSubmenu addItem:download];
    [projectSubmenu addItem:importItem];
    
    [self addItem:appMenu];
    [self addItem:fileMenu];
    [self addItem:projectMenu];
    [self addItem:[CPMenuItem separatorItem]];
}

@end