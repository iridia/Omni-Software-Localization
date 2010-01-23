@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Categories/CPArray+Find.j"
@import "../Views/OLLoginAndRegisterWindow.j"
@import "../Models/OLUser.j"

@implementation OLLoginController : CPObject
{
    CPWindow    loginAndRegisterWindow;
    id          delegate                @accessors;
    id          successfulLoginTarget   @accessors;
    SEL         successfulLoginAction   @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        loginAndRegisterWindow = [[OLLoginAndRegisterWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 300.0, 180.0) styleMask:CPTitledWindowMask];
        [loginAndRegisterWindow setDelegate:self];
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(showLoginAndRegisterWindow:)
            name:@"OLUserShouldLoginNotification"
            object:nil];
    }
    return self;
}

- (void)willLogin
{
    [loginAndRegisterWindow showLoggingIn];
}

- (void)hasLoggedIn:(OLUser)aUser
{
    [loginAndRegisterWindow close];
    
    var sessionManager = [OLUserSessionManager defaultSessionManager];
    [sessionManager setUser:aUser];

    [successfulLoginTarget performSelector:successfulLoginAction withObject:self];
}

- (void)loginFailed
{
    [loginAndRegisterWindow loginFailed];
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

- (void)showLoginAndRegisterWindow:(CPNotification)notification
{   
    successfulLoginTarget = nil;
    successfulLoginAction = nil;
    [[CPApplication sharedApplication] runModalForWindow:loginAndRegisterWindow];
    [loginAndRegisterWindow transitionToLoginView:nil];
    
    if([[[notification userInfo] allKeys] containsObject:@"StatusMessageText"])
    {
        [loginAndRegisterWindow setStatus:[[notification userInfo] objectForKey:@"StatusMessageText"]];
    }
    
    if([[[notification userInfo] allKeys] containsObject:@"SuccessfulLoginAction"] &&
        [[[notification userInfo] allKeys] containsObject:@"SuccessfulLoginTarget"])
    {
        successfulLoginTarget = [[notification userInfo] objectForKey:@"SuccessfulLoginTarget"];
        successfulLoginAction = [[notification userInfo] objectForKey:@"SuccessfulLoginAction"];
    }
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
    [aUser saveWithCallback:function(user)
    {
     [self hasLoggedIn:aUser];
    }];
}

- (void)registrationFailed
{
    [loginAndRegisterWindow registrationFailed]
}

@end
