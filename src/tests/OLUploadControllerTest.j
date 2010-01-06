@import "../Controllers/OLUploadController.j"

@implementation OLUploadControllerTest : OJTestCase

- (void)testThatOLUploadControllerDoesInitialize
{
	var target = [[OLUploadController alloc] init];
	[self assertNotNull:target];
}

-(void)testThatOLUploadControllerDoesHandleServerResponse
{
	var target = [[OLUploadContoller alloc] init];
	var jsonString = "<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">" + "{test:1}"+ "\n</pre>";
	
	[target handleServerResponse:jsonString];
	
	[self assert:{test:1} equals:[target jsonResponse]];
}

@end