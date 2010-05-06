@import <Foundation/CPObject.j>

@import "OLOpenIDController.j"
@import "../Utilities/OLUserSessionManager.j"
@import "../Categories/CPArray+Find.j"
@import "../Views/OLLoginAndRegisterView.j"
@import "../Models/OLUser.j"
@import "../Utilities/OLConstants.j"

@implementation OLLoginController : CPObject
{
    id                  delegate                @accessors;
    id                  successfulLoginTarget   @accessors;
    SEL                 successfulLoginAction   @accessors;

    CPWindow            loginAndRegisterWindow;
    CPView              loginAndRegisterView;
    OLOpenIDController  openIDController;
}

- (id)init
{
    if(self = [super init])
    {
        openIDController = [[OLOpenIDController alloc] init];
        [openIDController setDelegate:self];
        
        var frameRect = CGRectMake(0.0, 0.0, 300.0, 160.0);
        loginAndRegisterWindow = [[CPWindow alloc] initWithContentRect:frameRect styleMask:CPTitledWindowMask | CPClosableWindowMask];
        [loginAndRegisterWindow setTitle:@"Login/Register"];
        [loginAndRegisterWindow setDelegate:openIDController];
        
        loginAndRegisterView = [[OLLoginAndRegisterView alloc] initWithFrame:frameRect];
        [loginAndRegisterWindow setContentView:loginAndRegisterView];
        
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

- (void)hasLoggedIn:(OLUser)aUser
{
    [loginAndRegisterWindow close];
    
    var sessionManager = [OLUserSessionManager defaultSessionManager];
    [sessionManager setUser:aUser];

    [successfulLoginTarget performSelector:successfulLoginAction withObject:self];
}

- (void)loginFailed
{
    [loginAndRegisterView loginFailed];
}

- (void)didSubmitLogin:(CPDictionary)userInfo
{
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
    
    [[CPApplication sharedApplication] runModalForWindow:loginAndRegisterWindow];
    
    if([[notification userInfo] hasKey:@"StatusMessageText"])
    {
        [loginAndRegisterView setStatus:[[notification userInfo] objectForKey:@"StatusMessageText"]];
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
    [loginAndRegisterView registrationFailed]
}

@end
