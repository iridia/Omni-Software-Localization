@import "../Controllers/OLSidebarController.j"
@import <OJMoq/OJMoq.j>

@implementation OLSidebarControllerTest : OJTestCase

- (void)testThatOLSidebarControllerDoesInitialize
{
	var target = [[OLSidebarController alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLSidebarControllerDoesSetSidebarView
{
	var mockView = [[CPObject alloc] init]; // nothing should be called, so this is an effective stub
	var target = [[OLSidebarController alloc] init];
	
	[target setSidebarView:mockView];
	[self assert:mockView equals:[target sidebarView]];
}

- (void)testThatOLSidebarControllerDoesSetDelegate
{
	var mockDelegate = [[CPObject alloc] init]; // nothing should be called on the object, so this is an effective stub
	var target = [[OLSidebarController alloc] init];
	
	[target setDelegate:mockDelegate];
	[self assert:mockDelegate equals:[target delegate]];
}

- (void)testThatOLSidebarControllerDoesCallGoToResourcesView
{
	var mockDelegate = moq([[CPObject alloc] init]); // using moq because we need to verify the call to our delegate
	var target = [[OLSidebarController alloc] init];
	
	[mockDelegate expectThatSelector:@selector(contentViewSendMessage:) isCalled:1];
	
	[target setDelegate:mockDelegate];
	[target showResourcesView];
	
	[mockDelegate verifyThatAllExpectationsHaveBeenMet];
}

@end