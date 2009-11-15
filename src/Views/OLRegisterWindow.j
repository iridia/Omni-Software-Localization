@import "CPTextView.j"
@import "../Categories/CPColor+OLColors.j"

/*!
 * OLRegisterView
 *
 * The screen that is displayed when someone is registering.
 */
@implementation OLRegisterWindow : CPWindow
{
	id _delegate @accessors(property=delegate);
	CPTextField _userNameField;
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    if(self = [super initWithContentRect:rect styleMask:styleMask])
	{
		var contentView = [self contentView];

		var usernameText = [CPTextField labelWithTitle:@"Username"];
		var _userNameField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"Username" width:200];
		
		var registerButton = [CPButton buttonWithTitle:@"Register!"];
		var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
		/*
		var passwordText = [CPTextField labelWithTitle:@"Password"];
		var passwordField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"Password" width:200];
		
		var emailText = [CPTextField labelWithTitle:@"Email Address"];
		var emailField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"Email" width:200];
		
		var nameText = [CPTextField labelWithTitle:@"Name"];
		var nameField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"First,Last" width:200];
		
		*/		
		[self setBackgroundColor: [CPColor sourceViewColor]];
		var views = [usernameText, _userNameField, registerButton, cancelButton];
        [self addViews:views to:contentView];

		[registerButton setFrameOrigin:CGPointMake(120, 225)];
		[usernameText setFrameOrigin:CGPointMake(80, 25)];
		[_userNameField setFrameOrigin:CGPointMake(50, 50)];
		[cancelButton setFrameOrigin:CGPointMake(140, 150)];
		
 		[_userNameField setTextColor:[CPColor grayColor]];
		
		[registerButton setTarget:self];
		[registerButton setAction:@selector(register:)];
		
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

- (void)register:(id)sender
{
	values = [CPDictionary dictionary];
	[values setObject:[_userNameField stringValue] forKey:@"username"];
	[_delegate didSubmitRegistration:values];
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
