@import "../Controllers/OLLoginController.j"

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

// - (void)testThatOLLoginControllerDoesRespondToDidSubmitLogin
// {
// 	var target = [[OLLoginController alloc] init];
// 	var userInfo = [CPDictionary dictionary];
// 	[target didSubmitLogin:userInfo];
// 	[self assertTrue:YES];
// }

- (void)testThatOLLoginControllerDoesRespondToRegister
{
	var target = [[OLLoginController alloc] init];
	[target showRegister];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesRespondToDidSubmitRegistration
{
	var target = [[OLLoginController alloc] init];
	var registrationInfo = [CPDictionary dictionary];
	[target didSubmitRegistration:registrationInfo];
	[self assertTrue:YES];
}

- (void)testThatOLLoginControllerDoesRespondToShowLoginWindow
{
	var target = [[OLLoginController alloc] init];
	[target showLogin:moq()];
	[self assertTrue:YES];
}

@end