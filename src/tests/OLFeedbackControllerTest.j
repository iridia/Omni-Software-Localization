@import "../Controllers/OLFeedbackController.j"

CPApp = moq();
CPApp._windows = moq();

@implementation OLFeedbackControllerTest : OJTestCase

- (void)testThatOLFeedbackControllerDoesInitialize
{
	var target = [[OLFeedbackController alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLFeedbackControllerDoesRespondToShowFeedbackWindow
{
	var target = [[OLFeedbackController alloc] init];
	[target showFeedbackWindow];	
	[self assertTrue:YES];
}

- (void)testThatOLFeedbackControllerDoesRespondToWillCreateRecord
{
	var target = [[OLFeedbackController alloc] init];
	[target willCreateRecord];
	[self assertTrue:YES];
}

- (void)testThatOLFeedbackControllerDoesRespondToDidCreateRecord
{
	var target = [[OLFeedbackController alloc] init];
	[target didCreateRecord];
	[self assertTrue:YES];
}

- (void)testThatOLFeedbackControllerDoesRespondToUserDidChange
{
	//TODO
	var target = [[OLLoginController alloc] init];
	
	[target userDidChange];
	[self assertTrue:YES];
}

- (void)testThatOLFeedbackControllerDoesRespondToDidSubmitFeedback
{
	//TODO
	var target = [[OLLoginController alloc] init];
	var registrationInfo = [CPDictionary dictionary];
	[target didSubmitFeedback];
	[self assertTrue:YES];
}

@end