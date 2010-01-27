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
        [self reloadState:controller];
    }
    
    return self;
}

- (void)reloadState:(OLMenuController)controller
{
    for(var i = [self numberOfItems]-1; i >= 0; i--)
    {
        [self removeItemAtIndex:i];
    }
    
    var appMenu = [[CPMenuItem alloc] initWithTitle:@"Omni Software Localization" action:nil keyEquivalent:nil];
    var appSubmenu = [[CPMenu alloc] initWithTitle:@"AppMenu"];
    var feedbackItem = [[CPMenuItem alloc] initWithTitle:@"Send Feedback" action:@selector(feedback:) keyEquivalent:nil];
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
    
    var communityMenu = [[CPMenuItem alloc] initWithTitle:@"Community" action:nil keyEquivalent:nil];
    var communitySubmenu = [[CPMenu alloc] initWithTitle:@"CommunityMenu"];
    var loginItem = [[CPMenuItem alloc] initWithTitle:@"Login" action:@selector(login:) keyEquivalent:nil];
    var sendMessageItem = [[CPMenuItem alloc] initWithTitle:@"Send Message" action:@selector(sendMessage:) keyEquivalent:nil];
    
    [newLanguage setTarget:controller];
    [deleteLanguage setTarget:controller];
    [aboutItem setTarget:controller];
    [newItem setTarget:controller];
    [download setTarget:controller];
    [importItem setTarget:controller];
    [feedbackItem setTarget:controller];
    [loginItem setTarget:controller];
    [sendMessageItem setTarget:controller];
    
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
    
    [appSubmenu addItem:feedbackItem];
    [appSubmenu addItem:aboutItem];
    [appMenu setSubmenu:appSubmenu];
    
    [projectMenu setSubmenu:projectSubmenu];
    [projectSubmenu addItem:newLanguage];
    [projectSubmenu addItem:deleteLanguage];
    [projectSubmenu addItem:download];
    [projectSubmenu addItem:importItem];
    
    [communityMenu setSubmenu:communitySubmenu];
    [communitySubmenu addItem:loginItem];
    [communitySubmenu addItem:sendMessageItem];
    
    [self addItem:appMenu];
    [self addItem:fileMenu];
    [self addItem:projectMenu];
    [self addItem:communityMenu];
    [self addItem:[CPMenuItem separatorItem]];
}

@end