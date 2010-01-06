@import <OJMoq/OJMoq.j>
@import <AppKit/AppKit.j>
@import <Foundation/Foundation.j>
@import "../Controllers/OLUploadWindowController.j"

CPApp = moq();
CPApp._windows = moq();

@implementation OLUploadWindowControllerTest : OJTestCase

//Testing is not possible right now, due to the view code that is inside of OLUploadWindowController.

// - (void)testThatOLUploadWindowControllerTestDoesInitialize
// {
// 	var target = [[OLUploadWindowController alloc] init];
// 	[self assertNotNull:target];
// }
// 
// - (void)testThatOLUploadWindowControllerDoesStartUpload
// {
// 	var target = [[OLUploadWindowController alloc] init];
// 	CPApp = moq();
// 	
// 	[target startUpload];
// 	
// 	[CPApp expectSelector:@selector(runModalForWindow:) times:1];
// 	
// 	[CPApp verifyThatAllExpectationsHaveBeenMet];
// }


@end