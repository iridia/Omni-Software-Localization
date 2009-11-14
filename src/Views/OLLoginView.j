@import "OLView.j"
@import "CPTextView.j"
@import "../Categories/OLColors+CPColor.j"

/*!
 * OLLoginScreen
 *
 * The screen that is displayed when it becomes necessary for a user to login/register.
 */
@implementation OLLoginView : CPView
{
	id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)frame
{	
	if(self = [super initWithFrame:frame])
	{
        var loginText = [CPTextField labelWithTitle:@"Login"];
		var loginField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"Username" width:200];
		// Uncomment once DB supports passwords.
		//var passwordText = [CPTextField labelWithTitle:@"Import localizable files in order for them to be translated!"];
		var loginButton = [CPButton  buttonWithTitle:@"Login"];
		var registerText = [CPTextField labelWithTitle:@"New to OSL?  Register now!"];
        var registerButton = [CPButton buttonWithTitle:@"Register"];
		var cancelButton = [CPButton buttonWithTitle:@"Cancel"];

		[self setBackgroundColor:[CPColor sourceViewColor]];
		
        var views = [loginText, loginButton, registerButton, loginField, cancelButton, registerText];
        [self addViews:views];
		
		[registerButton setFrameOrigin:CGPointMake(120, 25)];
		[registerText setFrameOrigin:CGPointMake(80, 5)];
		[loginText setFrameOrigin:CGPointMake(50, 75)];
		[loginButton setFrameOrigin:CGPointMake(208, 150)];
		[cancelButton setFrameOrigin:CGPointMake(140, 150)];
		[loginField setFrameOrigin:CGPointMake(50, 90)];
		
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

- (void)addViews:(CPArray)views
{
	for(var i = 0; i < [views count]; i++)
	{
		[self addSubview:views[i]];
	}
}

- (void)login:(id)sender
{
	console.log("Login!");
	// ignore for now
}

- (void)transitionToRegisterPage:(id)sender
{
	console.log("Register!");
	// ignore for now
}

- (void)cancel
{
	console.log("Close!");
	// ignore for now
}

@end
