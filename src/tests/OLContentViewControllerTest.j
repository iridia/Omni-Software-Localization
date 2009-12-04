@import "../Controllers/OLContentViewController.j"
@import <OJMoq/OJMoq.j>

@implementation OLContentViewControllerTest : OJTestCase

- (void)testThatOLContentViewControllerDoesInitialize
{
	var target = [[OLContentViewController alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLContentViewControllerDoesSetContentController
{
	var target = [[OLContentViewController alloc] init];
	var mockController = [[CPObject alloc] init];
	
	[target setContentController:mockController];
	
	[self assert:mockController equals:[target contentController]];
}

- (void)testThatOLContentViewControllerDoesSetTransitionManager
{
	var mockManager = [[CPObject alloc] init];
	var target = [[OLContentViewController alloc] init];
	
	[target setTransitionManager:mockManager];
	
	[self assert:mockManager equals:[target transitionManager]];
}

- (void)testThatOLContentViewControllerDoesHandleMessage
{
	var target = [[OLContentViewController alloc] init];
	var mockManager = moq([[CPObject alloc] init]);
	
	[mockManager expectThatSelector:@selector(test) isCalled:1];
	
	[target setTransitionManager:mockManager];
	[target handleMessage:@selector(test)];
	
	[mockManager verifyThatAllExpectationsHaveBeenMet];
}

@end