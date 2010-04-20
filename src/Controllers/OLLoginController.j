@import <Foundation/CPObject.j>

@import "OLToolbarController.j"
@import "OLOpenIDController.j"
@import "../Utilities/OLUserSessionManager.j"
@import "../Categories/CPArray+Find.j"
@import "../Views/OLLoginAndRegisterWindow.j"
@import "../Models/OLUser.j"

OLLoginControllerShouldLoginNotification = @"OLLoginControllerShouldLoginNotification";
OLLoginControllerShouldLogoutNotification = @"OLLoginControllerShouldLogoutNotification"; //need to distribute across app

@implementation OLLoginController : CPObject
{
    CPWindow            loginAndRegisterWindow;
    id                  delegate                @accessors;
    id                  successfulLoginTarget   @accessors;
    SEL                 successfulLoginAction   @accessors;
    OLOpenIDController  openIDController;
}

- (id)init
{
    if(self = [super init])
    {
        loginAndRegisterWindow = [[OLLoginAndRegisterWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 300.0, 160.0) styleMask:CPTitledWindowMask | CPClosableWindowMask];
        openIDController = [[OLOpenIDController alloc] init];
        [loginAndRegisterWindow setDelegate:openIDController];
        [openIDController setDelegate:self];
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(showLoginAndRegisterWindow:)
            name:OLLoginControllerShouldLoginNotification
            object:nil];
            
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(didSubmitLogout)
            name:OLLoginControllerShouldLogoutNotification
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
    var email = [userInfo objectForKey:@"username"];
    [openIDController loginTo:email];
}

-(void)didSubmitLogout
{
    [[OLUserSessionManager defaultSessionManager] setStatus:OLUserSessionLoggedOutStatus];
}
- (void)showLoginAndRegisterWindow:(CPNotification)notification
{   
    successfulLoginTarget = nil;
    successfulLoginAction = nil;
    [loginAndRegisterWindow reset];
    [[CPApplication sharedApplication] runModalForWindow:loginAndRegisterWindow];
    
    if([[notification userInfo] hasKey:@"StatusMessageText"])
    {
        [loginAndRegisterWindow setStatus:[[notification userInfo] objectForKey:@"StatusMessageText"]];
    }
    
    if([[notification userInfo] hasKey:@"SuccessfulLoginAction"] &&
        [[notification userInfo] hasKey:@"SuccessfulLoginTarget"])
    {
        successfulLoginTarget = [[notification userInfo] objectForKey:@"SuccessfulLoginTarget"];
        successfulLoginAction = [[notification userInfo] objectForKey:@"SuccessfulLoginAction"];
    }
}

- (void)didSubmitRegistration:(CPString)email
{
    var user = [[OLUser alloc] initWithEmail:email];
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
