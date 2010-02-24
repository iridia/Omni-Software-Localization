@import <AppKit/AppKit.j>
@import <OJMoq/OJMoq.j>
@import "../Controllers/OLToolbarController.j"

CPApp = moq();
CPApp._windows = moq();

@implementation OLToolbarControllerTest : OJTestCase

- (void)testThatOLToolbarControllerTestDoesInitialize
{
	var target = [[OLToolbarController alloc] init];
	[self assertNotNull:target];
}

//The last selector (updateLoginInfo) is useful to test, but cannot yet be done under OJMoq.

@end