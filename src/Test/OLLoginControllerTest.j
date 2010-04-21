@import "../Controllers/OLLoginController.j"
@import "../Utilities/OLUserSessionManager.j"
@import "utilities/OLUserSessionManager+Testing.j"

CPApp = moq();
CPApp._windows = moq();

@implementation OLLoginControllerTest : OJTestCase

- (void)testThatOLLoginControllerDoesInitialize
{
	var target = [[OLLoginController alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLLoginControllerDoesRespondToWillLogin
{
	var target = [[OLLoginController alloc] init];
	[target willLogin];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesRespondToHasLoggedIn
{
	var target = [[OLLoginController alloc] init];
	var user = moq();
	[target hasLoggedIn:user];
	[self assertTrue:YES];
}

// OJMoq doesn't yet handle callbacks
// - (void)testThatOLLoginControllerDoesRespondToDidSubmitLogin
// {
//     var target = [[OLLoginController alloc] init];
//     var userInfo = [CPDictionary dictionary];
//     [target didSubmitLogin:userInfo];
//     [self assertTrue:YES];
// }

- (void)testThatOLLoginControllerDoesRespondToDidSubmitRegistration
{
	var target = [[OLLoginController alloc] init];
	var registrationInfo = [CPDictionary dictionary];
	[target didSubmitRegistration:registrationInfo];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesRespondToShowLoginWindow
{
    var notification = moq();
    
    [notification selector:@selector(userInfo) returns:[CPDictionary dictionary]];
    
	var target = [[OLLoginController alloc] init];
	[target showLoginAndRegisterWindow:notification];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesRespondToWillLogin
{
    var target = [[OLLoginController alloc] init];
	[target willLogin];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesForwardWillLogin
{
    var target = [[OLLoginController alloc] init];
    var loginAndRegisterWindowMoq = moq();
    target.loginAndRegisterWindow = loginAndRegisterWindowMoq;
    
    [loginAndRegisterWindowMoq selector:@selector(showLoggingIn) times:1];
    
	[target willLogin];
	
	[loginAndRegisterWindowMoq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLLoginControllerDoesRespondToHasLoggedIn
{
    var target = [[OLLoginController alloc] init];
    var loginAndRegisterWindowMoq = moq();
    target.loginAndRegisterWindow = loginAndRegisterWindowMoq;
	[target hasLoggedIn:moq()];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesCloseWindowOnHasLoggedIn
{
    var target = [[OLLoginController alloc] init];
	var loginAndRegisterWindowMoq = moq();
    target.loginAndRegisterWindow = loginAndRegisterWindowMoq;
    
    [loginAndRegisterWindowMoq selector:@selector(close) times:1];
    
	[target hasLoggedIn:moq()];
	
	[loginAndRegisterWindowMoq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLLoginControllerDoesSetUserOnHasLoggedIn
{
    var target = [[OLLoginController alloc] init];
    var loginAndRegisterWindowMoq = moq();
    target.loginAndRegisterWindow = loginAndRegisterWindowMoq;
    var mockedUser = moq();
    
	[target hasLoggedIn:mockedUser];
	
	[self assert:mockedUser equals:[[OLUserSessionManager defaultSessionManager] user]];
	[self assert:OLUserSessionLoggedInStatus equals:[[OLUserSessionManager defaultSessionManager] status]];
}


- (void)testThatOLLoginControllerDoesRespondToLoginFailed
{
    var target = [[OLLoginController alloc] init];
	[target loginFailed];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesForwardLoginFailed
{
    var target = [[OLLoginController alloc] init];
    var loginAndRegisterWindowMoq = moq();
    target.loginAndRegisterWindow = loginAndRegisterWindowMoq;
    
    [loginAndRegisterWindowMoq selector:@selector(loginFailed) times:1];
    
	[target loginFailed];
	
	[loginAndRegisterWindowMoq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLLoginControllerDoesRespondToDidSubmitRegistration
{
	var target = [[OLLoginController alloc] init];
	[target didSubmitRegistration:moq()];
	[self assertTrue:YES];
}

- (void)tearDown
{
    [OLUserSessionManager resetDefaultSessionManager];
}

@end