@import "../controllers/OLWelcomeController.j"
@import "utilities/OLControllerTestFactory.j"

@implementation OLWelcomeControllerTests : OJTestCase

- (void)testThatOLWelcomeControllerLoads
{
	var contentView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
	[self assert:[[OLWelcomeController alloc] initWithContentView:contentView]];
}

- (void)testThatOLWelcomeControllerDoesTransferToOLResourceView
{
	var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	[target transitionToResourceView:self];
	// still need to test something. This is difficult. This is a design smell!!
}

- (void)testThatOLWelcomeControllerDoesShowUploadingNotification
{
	var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	[target showUploading];
	// still need to test something. This is difficult. This is a design smell!!
}

- (void)testThatOLWelcomeControllerDoesShowFinishedUploadingNotification
{
	var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	[target finishedUploadingWithResponse:@"12345.gif"];
	// still need to test something. This is difficult. This is a design smell!!
}

- (void)testThatOLWelcomeControllerDoesDownloadFiles
{
	var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	[target downloadFile:nil];
	// still need to test something. This is difficult. This is a design smell!!
}


@end