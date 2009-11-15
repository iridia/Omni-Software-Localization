@import <Foundation/CPObject.j>
@import "../Categories/CPArray+Find.j"
@import "../Views/OLLoginWindow.j"
@import "../Views/OLRegisterWindow.j"
@import "../Models/OLUser.j"

@implementation OLLoginController : CPObject
{
	CPWindow _loginWindow;
	CPWindow _registerWindow;
}

- (id)init
{
	if(self = [super init])
	{
		_loginWindow = [[OLLoginWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
		_registerWindow = [[OLRegisterWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
		[_loginWindow setDelegate:self];
		[_registerWindow setDelegate:self];
	}
	return self;
}

- (void)willLogin
{
	[_loginWindow showLoggingIn];
}

- (void)hasLoggedIn:(OLUser)aUser
{
	[_loginWindow close];
}

- (void)loginFailed
{
	[_loginWindow showLoginFailed]
}

- (void)didSubmitLogin:(CPDictionary)userInfo
{
	[self willLogin];
	var users = [OLUser list];
	var foundUser = NO;
	var theUser;
	
	theUser = [users findBy:function(anotherUser){
		if([[anotherUser email] isEqualToString:[userInfo objectForKey:@"username"]])
		{
			foundUser = YES;
			return anotherUser;
		}}];
	
	if(!foundUser)
	{
		[self loginFailed];
	}
	else
	{
		[self hasLoggedIn:theUser];
	}
}

- (void)showRegister
{
	[_loginWindow close];
	[[CPApplication sharedApplication] runModalForWindow:_registerWindow];
}

- (void)showLogin:(id)sender
{
	[[CPApplication sharedApplication] runModalForWindow:_loginWindow];
}

- (void)didSubmitRegistration:(CPDictionary)registrationInfo
{
	var user = [[OLUser alloc] initWithEmail:[registrationInfo objectForKey:@"username"]];
	if([user email])
	{
		[user save];
	}
	[_registerWindow close];
}

@end