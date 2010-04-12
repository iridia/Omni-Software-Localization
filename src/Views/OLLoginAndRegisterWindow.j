@import "../Categories/CPColor+OLColors.j"
@import "../Categories/CPView+Positioning.j"

/*!
 * OLLoginScreen
 *
 * The screen that is displayed when it becomes necessary for a user to login/register.
 */
@implementation OLLoginAndRegisterWindow : CPWindow
{
	CPTextField emailTextField;
	CPTextField passwordTextField;
	CPTextField confirmPasswordTextField;
	
	CPButton    registerButton;
	CPButton    loginButton;
	CPTextField confirmPasswordText;
	
	CPTextField statusTextField;
	CGRect      originalSize;
	
	CPWebView   webView;
	
	id          delegate        @accessors;
}

- (id)initWithContentRect:(CGRect)aRect styleMask:(unsigned)aStyleMask
{
    if(self = [super initWithContentRect:aRect styleMask:aStyleMask])
	{
	    [self setTitle:@"Login"];
	    originalSize = aRect;
	    
        // Some padding for the view
        var paddedView = [[CPView alloc] initWithFrame:CGRectInset(aRect, 10.0, 10.0)];
        [paddedView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        var inputFont = [CPFont systemFontOfSize:16.0];
        
        statusTextField = [CPTextField labelWithTitle:@"Enter your credentials to login"];
        [statusTextField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [statusTextField setFont:[CPFont boldSystemFontOfSize:12.0]];
        [statusTextField sizeToFit];
        [paddedView addSubview:statusTextField positioned:CPViewTopAligned | CPViewWidthCentered relativeTo:paddedView withPadding:0];
        
        var openIdText = [CPTextField labelWithTitle:@"OpenID:"];
        [openIdText setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [paddedView addSubview:openIdText positioned:CPViewBelow relativeTo:statusTextField withPadding:0.0];
        
        var buttonWidth = 60.0;
        loginButton = [CPButton buttonWithTitle:@"Login"];
        [loginButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [loginButton setTarget:self];
        [loginButton setAction:@selector(loginWithGivenURL:)];
        [loginButton setWidth:buttonWidth];
        [self setDefaultButton:loginButton];

        openIdTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"user.myopenid.com" 
            width:CGRectGetWidth([paddedView bounds])-[loginButton frame].size.width-12.0];
        [openIdTextField setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [openIdTextField setFont:inputFont];
        [openIdTextField sizeToFit];
		[openIdTextField setTarget:self];
		[openIdTextField setAction:@selector(loginWithGivenURL:)];
        [paddedView addSubview:openIdTextField positioned:CPViewBelow relativeTo:openIdText withPadding:0];
        [paddedView addSubview:loginButton positioned:CPViewOnTheRight relativeTo:openIdTextField withPadding:12.0];
        [loginButton setCenter:CGPointMake([loginButton center].x, [openIdTextField center].y)];
        
        var googleButton = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
        [googleButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/googleB.png"]];
        [googleButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [googleButton setBordered:NO];
        [googleButton setTarget:delegate];
        [googleButton setAction:@selector(loginToGoogle:)];
        [paddedView addSubview:googleButton positioned:CPViewLeftAligned | CPViewBelow relativeTo:openIdTextField withPadding:12.0];
        
        var yahooButton = [[CPButton alloc] initWithFrame:CGRectMake(0, 0, 120, 32)];
        [yahooButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/yahooB.png"]];
        [yahooButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMaxYMargin];
        [yahooButton setBordered:NO];
        [yahooButton setTarget:delegate];
        [yahooButton setAction:@selector(loginToYahoo:)];
        [paddedView addSubview:yahooButton positioned:CPViewHeightSame | CPViewOnTheRight relativeTo:googleButton withPadding:12.0];
        
        [[self contentView] addSubview:paddedView];
	}
	return self;
}

- (void)loginWithGivenURL:(id)sender
{
    [delegate loginTo:[openIdTextField stringValue]];
}

- (void)cancel:(id)sender
{
	[self close];
}

- (void)reset
{
    [webView setMainFrameURL:"about:blank"];
    [self setFrame:originalSize];
}

- (void)close
{
    [super close];
    
    [[CPApplication sharedApplication] stopModal];
}

- (void)loginFailed
{
    [self setStatus:@"Login failed"];
    [statusTextField setTextColor:[CPColor errorColor]];
}

- (void)registrationFailed
{
    [self setStatus:@"Registration failed"];
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