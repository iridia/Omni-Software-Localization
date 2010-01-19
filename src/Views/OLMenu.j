@import <AppKit/CPMenu.j>

@import "../Controllers/OLFeedbackController.j"
@import "../Controllers/OLLoginController.j"
@import "../Controllers/OLUploadWindowController.j"

@implementation OLMenu : CPMenu
{
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
        var appMenu = [[CPMenuItem alloc] initWithTitle:@"Omni Software Localization" action:nil keyEquivalent:nil];
        var appSubmenu = [[CPMenu alloc] initWithTitle:@"AppMenu"];
        var aboutItem = [[CPMenuItem alloc] initWithTitle:@"About Omni Software Localization" action:@selector(about:) keyEquivalent:nil];
        var quitItem = [[CPMenuItem alloc] initWithTitle:@"Quit Omni Software Localization" action:@selector(quit:) keyEquivalent:"q"];
        
        [aboutItem setTarget:controller];
        [quitItem setTarget:controller];
        [appSubmenu addItem:aboutItem];
        [appSubmenu addItem:quitItem];
        [appMenu setSubmenu:appSubmenu];
        
        var fileMenu = [[CPMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:nil];
        var fileSubmenu = [[CPMenu alloc] initWithTitle:@"FileMenu"];
        var newItem = [[CPMenuItem alloc] initWithTitle:@"New..." action:@selector(new:) keyEquivalent:"n"];
        var saveItem = [[CPMenuItem alloc] initWithTitle:@"Save" action:@selector(save:) keyEquivalent:"s"];
        
        [fileSubmenu addItem:newItem];
        [fileSubmenu addItem:saveItem];
        
        [newItem setTarget:controller];
        [fileMenu setSubmenu:fileSubmenu];
        
        var projectMenu = [[CPMenuItem alloc] initWithTitle:@"Project" action:nil keyEquivalent:nil];
        var projectSubmenu = [[CPMenu alloc] initWithTitle:@"ProjectMenu"];
        var newLanguage = [[CPMenuItem alloc] initWithTitle:@"New Language.." action:@selector(newLanguage:) keyEquivalent:nil];
        var deleteLanguage = [[CPMenuItem alloc] initWithTitle:@"Delete Language.." action:@selector(deleteLanguage:) keyEquivalent:nil];
        
        [projectMenu setSubmenu:projectSubmenu];
        [projectSubmenu addItem:newLanguage];
        [projectSubmenu addItem:deleteLanguage];
        
        [newLanguage setTarget:controller];
        [deleteLanguage setTarget:controller];
        
        [self addItem:appMenu];
        [self addItem:fileMenu];
        [self addItem:projectMenu];
        [self addItem:[CPMenuItem separatorItem]];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
    }
    
    return self;
}

@end