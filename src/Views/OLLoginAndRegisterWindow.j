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
	
	id          delegate        @accessors;
}

- (id)initWithContentRect:(CGRect)aRect styleMask:(unsigned)aStyleMask
{
    if(self = [super initWithContentRect:aRect styleMask:aStyleMask])
	{
	    [self setTitle:@"Login"];
	    
        // Some padding for the view
        var paddedView = [[CPView alloc] initWithFrame:CGRectInset(aRect, 10.0, 10.0)];
        [paddedView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        var inputFont = [CPFont systemFontOfSize:16.0];
        
        statusTextField = [CPTextField labelWithTitle:@"Enter your email to login"];
        [statusTextField setFont:[CPFont boldSystemFontOfSize:12.0]];
        [statusTextField sizeToFit];
        [paddedView addSubview:statusTextField positioned:CPViewTopAligned | CPViewWidthCentered relativeTo:paddedView withPadding:0];
        
        var emailText = [CPTextField labelWithTitle:@"Email:"];
        [paddedView addSubview:emailText positioned:CPViewBelow relativeTo:statusTextField withPadding:0.0];

        emailTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"email@example.com" width:CGRectGetWidth([paddedView bounds])];
        [emailTextField setFont:inputFont];
        [emailTextField sizeToFit];
		[emailTextField setTarget:self];
		[emailTextField setAction:@selector(login:)];
        [paddedView addSubview:emailTextField positioned:CPViewBelow relativeTo:emailText withPadding:0];
        
        // Uncomment once DB supports passwords.
        var passwordText = [CPTextField labelWithTitle:@"Password:"];
        [paddedView addSubview:passwordText positioned:CPViewBelow relativeTo:emailTextField withPadding:5.0];
        [passwordText setTextColor:[CPColor grayColor]];
        
        passwordTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"Not Required" width:CGRectGetWidth([paddedView bounds])];
        [passwordTextField setSecure:YES];
        [passwordTextField setFont:inputFont];
        [passwordTextField sizeToFit];
        [passwordTextField setEnabled:NO];
        [paddedView addSubview:passwordTextField positioned:CPViewBelow relativeTo:passwordText withPadding:0];
        
        confirmPasswordText = [CPTextField labelWithTitle:@"Confirm Password:"];
        [confirmPasswordText setHidden:YES];
        [paddedView addSubview:confirmPasswordText positioned:CPViewBelow relativeTo:passwordTextField withPadding:5.0];
        [confirmPasswordText setTextColor:[CPColor grayColor]];
        
        confirmPasswordTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"Not Required" width:CGRectGetWidth([paddedView bounds])];
        [confirmPasswordTextField setSecure:YES];
        [confirmPasswordTextField setFont:inputFont];
        [confirmPasswordTextField sizeToFit];
        [confirmPasswordTextField setHidden:YES];
        [confirmPasswordTextField setEnabled:NO];
        [paddedView addSubview:confirmPasswordTextField positioned:CPViewBelow relativeTo:confirmPasswordText withPadding:0];
        
        var buttonsView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([paddedView bounds]), 32.0)];
        [buttonsView setAutoresizingMask:CPViewMinYMargin];
        [paddedView addSubview:buttonsView positioned:CPViewLeftAligned | CPViewBottomAligned relativeTo:paddedView withPadding:0];
        
        var buttonWidth = 60.0;
        loginButton = [CPButton  buttonWithTitle:@"Login"];
        [loginButton setTarget:self];
        [loginButton setAction:@selector(login:)];
        [loginButton setAutoresizingMask:CPViewMinYMargin];
        [loginButton setWidth:buttonWidth];
        [self setDefaultButton:loginButton];
        [buttonsView addSubview:loginButton positioned:CPViewRightAligned | CPViewBottomAligned relativeTo:buttonsView withPadding:0];

        registerButton = [CPButton buttonWithTitle:@"Register"];
        [registerButton setTarget:self];
        [registerButton setAction:@selector(transitionToRegisterView:)];
        [registerButton setWidth:buttonWidth];
        [buttonsView addSubview:registerButton positioned:CPViewLeftAligned | CPViewBottomAligned relativeTo:buttonsView withPadding:0];
        
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(cancel:)];
        [cancelButton setWidth:buttonWidth];
        [buttonsView addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:loginButton withPadding:5.0];
        
        [[self contentView] addSubview:paddedView];
        [self setDelegate:self];
	}
	return self;
}

- (void)login:(id)sender
{
    var values = [CPDictionary dictionary];
    [values setObject:[emailTextField stringValue] forKey:@"username"];
    [delegate didSubmitLogin:values];
}

- (void)register:(id)sender
{
    var values = [CPDictionary dictionary];
	[values setObject:[emailTextField stringValue] forKey:@"username"];
	[delegate didSubmitRegistration:values];
}

- (void)transitionToRegisterView:(id)sender
{
    if ([confirmPasswordText isHidden])
    {    
        var currentFrame = [self frame];
        currentFrame.size.height += CGRectGetHeight([confirmPasswordTextField bounds]) + CGRectGetHeight([confirmPasswordText bounds]);
        [self setFrame:currentFrame display:YES animate:YES];
        
        var cachedLoginButtonFrameOrigin = [loginButton frame].origin;
    	[loginButton setFrameOrigin:[registerButton frame].origin];
    	[registerButton setFrameOrigin:cachedLoginButtonFrameOrigin];
    }
    
	[confirmPasswordTextField setHidden:NO];
	[confirmPasswordText setHidden:NO];
	
	[loginButton setAction:@selector(transitionToLoginView:)];
	[registerButton setAction:@selector(register:)];
	[self setDefaultButton:registerButton];
	
	[statusTextField setStringValue:@"Enter your email to register"];
    [statusTextField setTextColor:[CPColor blackColor]];
	[self centerStatusTextField];
	
	[self setTitle:@"Register"];
    
    [self makeFirstResponder:emailTextField];
}

- (void)transitionToLoginView:(id)sender
{
    if (![confirmPasswordText isHidden])
    {    
        var currentFrame = [self frame];
        currentFrame.size.height -= CGRectGetHeight([confirmPasswordTextField bounds]) + CGRectGetHeight([confirmPasswordText bounds]);
        [self setFrame:currentFrame display:YES animate:YES];
        
        var cachedLoginButtonFrameOrigin = [loginButton frame].origin;
    	[loginButton setFrameOrigin:[registerButton frame].origin];
    	[registerButton setFrameOrigin:cachedLoginButtonFrameOrigin];
    }
    
	[confirmPasswordTextField setHidden:YES];
	[confirmPasswordText setHidden:YES];
	
	[loginButton setAction:@selector(login:)];
	[self setDefaultButton:loginButton];
	[registerButton setAction:@selector(transitionToRegisterView:)];
	
	[statusTextField setStringValue:@"Enter your email to login"];
    [statusTextField setTextColor:[CPColor blackColor]];
	[self centerStatusTextField];
	
	[self setTitle:@"Login"];
    
    [self makeFirstResponder:emailTextField];
}

- (void)cancel:(id)sender
{
	[self close];
}

- (void)close
{
    // order us out
    [super close];
    
    [[CPApplication sharedApplication] stopModal];
	
    [self transitionToLoginView:self];
}

- (void)showLoggingIn
{
	// nothing
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