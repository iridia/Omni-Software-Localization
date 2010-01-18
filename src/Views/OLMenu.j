@import <AppKit/CPMenu.j>

@import "../Controllers/OLFeedbackController.j"
@import "../Controllers/OLLoginController.j"
@import "../Controllers/OLUploadWindowController.j"

@implementation OLMenu : CPMenu
{
    OLFeedbackController _feedbackController;
	OLLoginController _loginController;
	OLUploadWindowController uploadWindowController;
	CPMenuItem _loginItem;
	CPAlert alert;
}

- (id)initWithTitle:(CPString)title
{
    self = [super initWithTitle:title];
    
    if (self)
    {
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
        
        [self addItem:appMenu];
        [self addItem:fileMenu];
        [self addItem:projectMenu];
        [self addItem:[CPMenuItem separatorItem]];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
    }
    
    return self;
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

- (void)updateLoginItemWithTitle:(CPString)aTitle
{
	[_loginItem setTitle:aTitle];
}

- (void)quit:(id)sender
{
    // TODO: Make the app quit
}

@end