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
        _feedbackController = [[OLFeedbackController alloc] init];
        var feedbackItem = [[CPMenuItem alloc] initWithTitle:@"Send Feedback" action:@selector(showFeedbackWindow:) keyEquivalent:@"f"];
        [feedbackItem setTarget:_feedbackController];
        
        var feedbackImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Feedback.png" size:CPMakeSize(24, 24)];
        [feedbackItem setImage:feedbackImage];
        [feedbackItem setAlternateImage:feedbackImage];
        
        [self insertItem:feedbackItem atIndex:0];

		_loginController = [[OLLoginController alloc] init];
		[_loginController setDelegate:self];
		_loginItem = [[CPMenuItem alloc] initWithTitle:@"Login / Register" action:@selector(showLogin:) keyEquivalent:@"l"];
		[_loginItem setTarget:_loginController];
		
		var loginImage = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/User.png" size:CPMakeSize(24, 24)];
		[_loginItem setImage:loginImage];
		[_loginItem setAlternateImage:loginImage];
		
		[self insertItem:_loginItem atIndex:1];
    }
    
    return self;
}

- (void)updateLoginItemWithTitle:(CPString)aTitle
{
	[_loginItem setTitle:aTitle];
}

@end