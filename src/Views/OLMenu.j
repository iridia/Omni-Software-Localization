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
        var aboutItem = [[CPMenuItem alloc] initWithTitle:@"About" action:@selector(about:) keyEquivalent:nil];
        var quitItem = [[CPMenuItem alloc] initWithTitle:@"Quit" action:nil keyEquivalent:"q"];
        
        [aboutItem setTarget:self];
        [appSubmenu addItem:aboutItem];
        [appSubmenu addItem:quitItem];
        [appMenu setSubmenu:appSubmenu];
        
        var fileMenu = [[CPMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:nil];
        var fileSubmenu = [[CPMenu alloc] initWithTitle:@"FileMenu"];
        var newItem = [[CPMenuItem alloc] initWithTitle:@"New..." action:@selector(new:) keyEquivalent:"n"];
        
        [fileSubmenu addItem:newItem];
        
        [newItem setTarget:self];
        [fileMenu setSubmenu:fileSubmenu];
        
        [self addItem:appMenu];
        [self addItem:fileMenu];
        [self addItem:[CPMenuItem separatorItem]];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
    }
    
    return self;
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
    [uploadWindowController startUpload];
}

- (void)updateLoginItemWithTitle:(CPString)aTitle
{
	[_loginItem setTitle:aTitle];
}

@end