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
	CPTextField _registrationFailed;
}

- (id)initWithContentRect:(CGRect)rect styleMask:(unsigned)styleMask
{
    if(self = [super initWithContentRect:rect styleMask:styleMask])
	{
		[self setTitle:@"Register"];
		var contentView = [self contentView];

		var usernameText = [CPTextField labelWithTitle:@"Login"];
		var _userNameField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"E-mail address" width:200];
		
		var registerButton = [CPButton buttonWithTitle:@"Register"];
		var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
		_registrationFailed = [CPTextField labelWithTitle:"That's not a valid email address!"];
		[_registrationFailed setTextColor:[CPColor redColor]];

		[self setBackgroundColor: [CPColor sourceViewColor]];
		var views = [usernameText, _userNameField, registerButton, cancelButton];
        [self addViews:views to:contentView];

		[registerButton setFrameOrigin:CGPointMake(190, 75)];
		[usernameText setFrameOrigin:CGPointMake(50, 15)];
		[_userNameField setFrameOrigin:CGPointMake(50, 30)];
		[cancelButton setFrameOrigin:CGPointMake(130, 75)];
		[_registrationFailed setFrameOrigin:CGPointMake(70, 55)];
		
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

- (void)showRegistrationFailed
{
	[[self contentView] addSubview:_registrationFailed];
}
