@import <Foundation/CPObject.j>
@import "../Categories/CPArray+Find.j"
@import "../Views/OLLoginWindow.j"
@import "../Views/OLRegisterWindow.j"
@import "../Models/OLUser.j"

@implementation OLLoginController : CPObject
{
	CPWindow _loginWindow;
	CPWindow _registerWindow;
	id _delegate @accessors(property=delegate);
}

- (id)init
{
	if(self = [super init])
	{
		_loginWindow = [[OLLoginWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 200) styleMask:CPTitledWindowMask];
		_registerWindow = [[OLRegisterWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 120) styleMask:CPTitledWindowMask];
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
    
    var sessionManager = [CPUserSessionManager defaultManager];
    [sessionManager setStatus:CPUserSessionLoggedInStatus];
    [sessionManager setUserIdentifier:[aUser recordID]];
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLLoginDidLogin"
        object:self];
}

- (void)loginFailed
{
	[_loginWindow showLoginFailed]
}

- (void)didSubmitLogin:(CPDictionary)userInfo
{
	[self willLogin];
	var foundUser = NO;
	[OLUser listWithCallback:function(user){if([[user email] isEqualToString:[userInfo objectForKey:@"username"]])
	    {
	        foundUser = YES;
	        [self hasLoggedIn:user];
	    }} finalCallback:function(){if(!foundUser){[self loginFailed];}}];
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
		[self hasRegistered:user];
	}
	else
	{
		[self registrationFailed];
	}
}

- (void)hasRegistered:(OLUser)aUser
{
	[aUser save];
	[_registerWindow close];
	[self showLogin:self];
}

- (void)registrationFailed
{
	[_registerWindow showRegistrationFailed]
}

@end

function makeLoggedInTitle(user)
{
	var email = [user email];
	return "Welcome, " + email + "!";
}