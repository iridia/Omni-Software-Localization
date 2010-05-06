@import "../Categories/CPColor+OLColors.j"
@import "../Categories/CPView+Positioning.j"

/*!
 * OLLoginScreen
 *
 * The screen that is displayed when it becomes necessary for a user to login/register.
 */
@implementation OLLoginAndRegisterView : CPView
{
	CPButton    loginButton;
	
	CPTextField statusTextField;
	CPTextField openIdTextField;
	CGRect      originalSize;
	
	id          delegate        @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
	{
        var inputFont = [CPFont systemFontOfSize:16.0];
        
        statusTextField = [CPTextField labelWithTitle:@"Enter your credentials to login or register."];
        [statusTextField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [statusTextField setFont:[CPFont boldSystemFontOfSize:12.0]];
        [statusTextField sizeToFit];
        [self addSubview:statusTextField positioned:CPViewTopAligned | CPViewWidthCentered relativeTo:self withPadding:12.0];
        
        var openIdText = [CPTextField labelWithTitle:@"OpenID:"];
        [openIdText setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [self addSubview:openIdText positioned:CPViewBelow relativeTo:statusTextField withPadding:12.0];
        var currentOrigin = [openIdText frame].origin;
        [openIdText setFrameOrigin:CPMakePoint(currentOrigin.x + 12.0, currentOrigin.y)];

        loginButton = [CPButton buttonWithTitle:@"Login"];
        [loginButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [loginButton setTarget:self];
        [loginButton setAction:@selector(loginWithGivenURL:)];
        [loginButton setWidth:60.0];
        // [self setDefaultButton:loginButton];
        
        openIdTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"user.myopenid.com" width:CGRectGetWidth([self bounds])-[loginButton frame].size.width-36.0];
        [openIdTextField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [openIdTextField setFont:inputFont];
        [openIdTextField sizeToFit];
		[openIdTextField setTarget:self];
		[openIdTextField setAction:@selector(loginWithGivenURL:)];
        [self addSubview:openIdTextField positioned:CPViewBelow | CPViewLeftSame relativeTo:openIdText withPadding:0];
        
        [self addSubview:loginButton positioned:CPViewOnTheRight relativeTo:openIdTextField withPadding:12.0];

        [loginButton setCenter:CGPointMake([loginButton center].x, [openIdTextField center].y)];

        var googleButton = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
        [googleButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/googleB.png"]];
        [googleButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [googleButton setBordered:NO];
        [googleButton setTarget:delegate];
        [googleButton setAction:@selector(loginToGoogle:)];
        [self addSubview:googleButton positioned:CPViewLeftAligned | CPViewBottomAligned relativeTo:self withPadding:12.0];
        
        var yahooButton = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
        [yahooButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/yahooB.png"]];
        [yahooButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [yahooButton setBordered:NO];
        [yahooButton setTarget:delegate];
        [yahooButton setAction:@selector(loginToYahoo:)];
        [self addSubview:yahooButton positioned:CPViewRightAligned | CPViewBottomAligned relativeTo:self withPadding:12.0];
	}
	return self;
}

- (void)viewDidMoveToWindow
{
    [[self window] setDefaultButton:loginButton];
}

- (void)loginWithGivenURL:(id)sender
{
    [delegate loginTo:[openIdTextField stringValue]];
}

- (void)close
{
    [super close];
    
    [[CPApplication sharedApplication] stopModal];
}

- (void)loginFailed
{
    [self setStatus:@"Login failed. Please try again."];
    [statusTextField setTextColor:[CPColor errorColor]];
}

- (void)registrationFailed
{
    [self setStatus:@"Registration failed. Please try again."];
    [statusTextField setTextColor:[CPColor errorColor]];
}

- (void)centerStatusTextField
{
	[statusTextField sizeToFit];
    [statusTextField centerHorizontally];
}

- (void)setStatus:(CPString)statusMessage
{
    [statusTextField setStringValue:statusMessage];
    [self centerStatusTextField];
}

@end