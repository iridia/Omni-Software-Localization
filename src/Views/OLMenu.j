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
}

- (id)initWithTitle:(CPString)title
{
    self = [super initWithTitle:title];
    
    if (self)
    {
        var fileMenu = [[CPMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:nil];
        var fileSubmenu = [[CPMenu alloc] initWithTitle:@"FileMenu"];
        var newItem = [[CPMenuItem alloc] initWithTitle:@"New..." action:@selector(new:) keyEquivalent:"N"];
        
        [fileSubmenu addItem:newItem];
        
        [newItem setTarget:self];
        [fileMenu setSubmenu:fileSubmenu];
        
        [self addItem:fileMenu];
        [self addItem:[CPMenuItem separatorItem]];
        
        uploadWindowController = [[OLUploadWindowController alloc] init];
    }
    
    return self;
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