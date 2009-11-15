@import "../Categories/CPColor+OLColors.j"

/*!
 * OLLoginScreen
 *
 * The screen that is displayed when it becomes necessary for a user to login/register.
 */
@implementation OLLoginWindow : CPWindow
{
	id _delegate @accessors(property=delegate);
	CPTextField _userNameField;
	CPTextField _loginFailed;
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    if(self = [super initWithContentRect:rect styleMask:styleMask])
	{
		var contentView = [self contentView];
		[self setTitle:@"Login"];
		
        var loginText = [CPTextField labelWithTitle:@"Login"];
		_userNameField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"E-mail address" width:200];
		// Uncomment once DB supports passwords.
		//var passwordText = [CPTextField labelWithTitle:@"Import localizable files in order for them to be translated!"];
		var loginButton = [CPButton  buttonWithTitle:@"Login"];
		var registerText = [CPTextField labelWithTitle:@"New to OSL?  Register now!"];
        var registerButton = [CPButton buttonWithTitle:@"Register"];
		var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
		_loginFailed = [CPTextField labelWithTitle:"That's not a valid login!"];
		
		[_loginFailed setTextColor:[CPColor redColor]];

		[self setBackgroundColor:[CPColor sourceViewColor]];
		
        var views = [loginText, loginButton, registerButton, _userNameField, cancelButton, registerText];
        [self addViews:views to:contentView];
		
		[registerButton setFrameOrigin:CGPointMake(120, 25)];
		[registerText setFrameOrigin:CGPointMake(80, 5)];
		[loginText setFrameOrigin:CGPointMake(50, 75)];
		[loginButton setFrameOrigin:CGPointMake(208, 150)];
		[cancelButton setFrameOrigin:CGPointMake(140, 150)];
		[_userNameField setFrameOrigin:CGPointMake(50, 90)];
		[_loginFailed setFrameOrigin:CGPointMake(70, 120)];
		
		[loginText setTextColor:[CPColor blackColor]];
		[registerText setTextColor:[CPColor blackColor]];
		
		[loginButton setTarget:self];
		[loginButton setAction:@selector(login:)];
		
		[registerButton setTarget:self];
		[registerButton setAction:@selector(transitionToRegisterPage:)];
		
		[cancelButton setTarget:self];
		[cancelButton setAction:@selector(cancel)];
	}
	return self;
}

- (void)addViews:(CPArray)views to:(CPView)aView
{
	for(var i = 0; i < [views count]; i++)
	{
		[aView addSubview:views[i]];
	}
}

- (void)login:(id)sender
{
	var values = [CPDictionary dictionary];
	[values setObject:[_userNameField stringValue] forKey:@"username"];
	[_delegate didSubmitLogin:values];
}

- (void)transitionToRegisterPage:(id)sender
{
	[_delegate showRegister];
}

- (void)cancel
{
	[self close];
}

- (void)close
{
	[[CPApplication sharedApplication] stopModal];
	[self orderOut:self];
}

- (void)showLoggingIn
{
	// do nothing for now
}

- (void)showLoginFailed
{
	[[self contentView] addSubview:_loginFailed]; 
}

@end
