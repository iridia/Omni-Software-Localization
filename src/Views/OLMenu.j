@import <AppKit/CPMenu.j>

@import "../Controllers/OLFeedbackController.j"
@import "../Controllers/OLLoginController.j"
@import "../Controllers/OLUploadWindowController.j"

OLMenuItemNew = @"OLMenuItemNew";
OLMenuItemSave = @"OLMenuItemSave";
OLMenuItemNewLanguage = @"OLMenuItemNewLanguage";
OLMenuItemDeleteLanguage = @"OLMenuItemDeleteLanguage";

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
    var aboutItem = [[CPMenuItem alloc] initWithTitle:@"About Omni Software Localization" action:@selector(about:) keyEquivalent:nil];
    
    
    var fileMenu = [[CPMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:nil];
    var fileSubmenu = [[CPMenu alloc] initWithTitle:@"FileMenu"];
    var newItem = [[CPMenuItem alloc] initWithTitle:@"New..." action:@selector(new:) keyEquivalent:"n"];
    var saveItem = [[CPMenuItem alloc] initWithTitle:@"Save" action:@selector(save:) keyEquivalent:"s"];
    
    
    var projectMenu = [[CPMenuItem alloc] initWithTitle:@"Project" action:nil keyEquivalent:nil];
    var projectSubmenu = [[CPMenu alloc] initWithTitle:@"ProjectMenu"];
    var newLanguage = [[CPMenuItem alloc] initWithTitle:@"New Language.." action:@selector(newLanguage:) keyEquivalent:nil];
    var deleteLanguage = [[CPMenuItem alloc] initWithTitle:@"Delete Language.." action:@selector(deleteLanguage:) keyEquivalent:nil];
    
    [newLanguage setTarget:controller];
    [deleteLanguage setTarget:controller];
    [aboutItem setTarget:controller];
    [newItem setTarget:controller];
    
    var items = [controller items];

    [newItem setEnabled:[items objectForKey:OLMenuItemNew]];
    [saveItem setEnabled:[items objectForKey:OLMenuItemSave]];
    [newLanguage setEnabled:[items objectForKey:OLMenuItemNewLanguage]];
    [deleteLanguage setEnabled:[items objectForKey:OLMenuItemDeleteLanguage]];
    
    [fileSubmenu addItem:newItem];
    [fileSubmenu addItem:saveItem];
    
    [fileMenu setSubmenu:fileSubmenu];
    
    [appSubmenu addItem:aboutItem];
    [appMenu setSubmenu:appSubmenu];
    
    [projectMenu setSubmenu:projectSubmenu];
    [projectSubmenu addItem:newLanguage];
    [projectSubmenu addItem:deleteLanguage];
    
    [self addItem:appMenu];
    [self addItem:fileMenu];
    [self addItem:projectMenu];
    [self addItem:[CPMenuItem separatorItem]];
}

@end