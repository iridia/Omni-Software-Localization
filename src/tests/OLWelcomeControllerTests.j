@import <AppKit/AppKit.j>
@import "../controllers/OLWelcomeController.j"
@import "utilities/OLControllerTestFactory.j"

@implementation OLWelcomeControllerTests : OJTestCase

- (void)testThatOLWelcomeControllerLoads
{
	// var contentView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
	// [self assert:[[OLWelcomeController alloc] initWithContentView:contentView]];
}

- (void)testThatOLWelcomeControllerDoesTransferToOLResourceView
{
	// var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	// [target set_contentView:[OJMoq mockBaseObject:[[CPView alloc] initWithFrame:CGRectMakeZero()]]];
	
	// [target transitionToResourceView:self];
	// [self assert:[[target _contentView] subviews] contains:[target _resourceView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _uploadingView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _uploadedView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _welcomeView]];
}

- (void)testThatOLWelcomeControllerDoesShowUploadingNotification
{
	// var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	// [target showUploading];
	// [self assert:[[target _contentView] subviews] contains:[target _uploadingView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _resourceView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _uploadedView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _welcomeView]];
}

- (void)testThatOLWelcomeControllerDoesShowFinishedUploadingNotification
{
	// var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	// [target finishedUploadingWithResponse:@"12345.gif"];
	// [self assert:[[target _contentView] subviews] contains:[target _uploadedView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _resourceView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _uploadingView]];
	// [self assert:[[target _contentView] subviews] doesNotContain:[target _welcomeView]];
}

- (void)testThatOLWelcomeControllerDoesDownloadFiles
{
	// var target = [OLControllerTestFactory welcomeControllerWithFrame:CGRectMakeZero()];
	
	// [target downloadFile:nil];
}


@end