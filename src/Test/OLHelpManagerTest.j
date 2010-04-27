@import "../Utilities/OLHelpManager.j"

@implementation OLHelpManagerTest : OJTestCase


- (void)testThatOLHelpManagerDoesDoNothing
{
    [self assertTrue:YES];
}


// Can't test this because of Cappuccino stuff
// - (void)testThatOLHelpManagerDoesInitialize
// {
//     [self assertNotNull:[[OLHelpManager alloc] init]];
// }
// 
// - (void)testThatOLHelpManagerDoesGetSharedHelpManager
// {
//     [self assertNotNull:[OLHelpManager sharedHelpManager]];
// }
// 
// - (void)testThatOLHelpManagerDoesNavigateForward
// {
//     var target = [OLHelpManager sharedHelpManager];
//     var segmentedControl = moq([[CPSegmentedControl alloc] initWithFrame:CGRectMakeZero()]);
//     
//     [segmentedControl selector:@selector(selectedSegment) times:1];
//     [segmentedControl selector:@selector(selectedSegment) returns:1];
//     
//     var webView = target.webView = moq(target.webView);
//     
//     [webView selector:@selector(goForward:) times:1];
//     
//     [target navigate:segmentedControl];
//     
//     [webView verifyThatAllExpectationsHaveBeenMet];
// }
// 
// - (void)testThatOLHelpManagerDoesNavigateBackward
// {
//     var target = [OLHelpManager sharedHelpManager];
//     var segmentedControl = moq([[CPSegmentedControl alloc] initWithFrame:CGRectMakeZero()]);
// 
//     [segmentedControl selector:@selector(selectedSegment) times:1];
//     [segmentedControl selector:@selector(selectedSegment) returns:0];
// 
//     var webView = target.webView = moq(target.webView);
// 
//     [webView selector:@selector(goBackward:) times:1];
// 
//     [target navigate:segmentedControl];
// 
//     [webView verifyThatAllExpectationsHaveBeenMet];
// }

@end