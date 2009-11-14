@import "CPTextView.j"
@import "../Categories/OLColors+CPColor.j"

/*!
 * OLRegisterView
 *
 * The screen that is displayed when someone is registering.
 */
@implementation OLRegisterView : CPView
{
	id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{

		var usernameText = [CPTextField labelWithTitle:@"Username"];
		var usernameField = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"Username" width:200];
		
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
		var views = [usernameText, usernameField, registerButton, cancelButton];
        [self addViews:views];

		[registerButton setFrameOrigin:CGPointMake(120, 225)];
		[usernameText setFrameOrigin:CGPointMake(80, 25)];
		[usernameField setFrameOrigin:CGPointMake(50, 50)];
		[cancelButton setFrameOrigin:CGPointMake(140, 150)];
		
 		[usernameText setTextColor:[CPColor grayColor]];
		
		[registerButton setTarget:self];
		[registerButton setAction:@selector(register:)];
		
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

- (void)register:(id)sender
{
	console.log("Registered!");
	// ignore for now
}

- (void)cancel
{
	console.log("Close!");
	// ignore for now
}