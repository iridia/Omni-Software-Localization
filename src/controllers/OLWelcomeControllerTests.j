@import <AppKit/AppKit.j>
@import "OLWelcomeController.j"
@import "../testutilities/OLControllerTestFactory.j"
@import "../testutilities/OJTestCase+ArrayAsserts.j"

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
	[self assert:[[target _contentView] subviews] doesNotContain:[target _welcomeView]];
	[self assert:[[target _contentView] subviews] contains:[target _resourceView]];
	[self assertNotNull:[[target _resourceView]]];
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

@end