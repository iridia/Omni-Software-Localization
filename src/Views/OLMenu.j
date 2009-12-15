@import <AppKit/CPMenu.j>

@import "../Controllers/OLFeedbackController.j"
@import "../Controllers/OLLoginController.j"

@implementation OLMenu : CPMenu
{
    OLFeedbackController _feedbackController;
	OLLoginController _loginController;
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
    }
    
    return self;
}

- (void)new:(id)sender
{
    alert("Hello World!");
}

- (void)updateLoginItemWithTitle:(CPString)aTitle
{
	[_loginItem setTitle:aTitle];
}

@end