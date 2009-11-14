@import <AppKit/AppKit.j>
@import "../Managers/OLTransitionManager.j"
@import "../Controllers/OLContentViewController.j"
@import "utilities/OJMoq/OJMoq.j"

@implementation OLTransitionManagerTest : OJTestCase

- (void)testThatOLTransitionManagerDoesInitialize
{
	var target = [[OLTransitionManager alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLTransitionManagerDoesSetDelegate
{
	var target = [[OLTransitionManager alloc] init];
	var mockDelegate = [[CPObject alloc] init];
	
	[target setDelegate:mockDelegate];
	
	[self assert:mockDelegate equals:[target delegate]];
}

// Because of Views being created here. I'm fine with this, because this is all
// located in one spot now instead of being spread throughout the controllers.
// - (void)testThatOLTransitionManagerDoesTransitionToResourcesView
// {
// 	var target = [[OLTransitionManager alloc] init];
// 	var mockDelegate = moq([[CPObject alloc] init]);
// 	
// 	[mockDelegate expectThatSelector:@selector(setContentController:) isCalled:1];
// 	[target setDelegate:mockDelegate];
// 	
// 	[target transitionToResourcesView];
// 	
// 	[mockDelegate verifyThatAllExpectationsHaveBeenMet];
// }
// 
// - (void)testThatOLTransitionManagerDoesCacheResourcesController
// {
// 	var target = [[OLTransitionManager alloc] init];
// 	var mockDelegate = [[OLContentViewController alloc] init];
// 	
// 	[target setDelegate:mockDelegate];
// 
// 	[target transitionToResourcesView];
// 	var currentController = [mockDelegate contentController];
// 	
// 	[target transitionToResourcesView];
// 
// 	[self assert:currentController equals:[mockDelegate contentController]];
// }

@end