@import "../Controllers/OLUploadController.j"
@import "utilities/CPNotificationCenter+MockDefaultCenter.j"

@implementation OLUploadControllerTest : OJTestCase

- (void)setUp
{
    [CPNotificationCenter setIsMocked:YES];
}

- (void)tearDown
{
    [CPNotificationCenter setIsMocked:NO];
}

- (void)testThatOLUploadControllerDoesInitialize
{
	var target = [[OLUploadController alloc] init];
	[self assertNotNull:target];
}

-(void)testThatOLUploadControllerDoesHandleServerResponse
{
	var target = [[OLUploadController alloc] init];
	var jsonString = "<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">" + "{test:1}"+ "\n</pre>";

	[target handleServerResponse:jsonString];
	
	[self assertTrue:{test:1}.test == [target jsonResponse].test];
}

- (void)testThatOLUploadControllerDoesPostNotificationOnHandleServerResponse
{
    [[CPNotificationCenter defaultCenter] selector:@selector(postNotificationName:object:) times:1];
    
    var target = [[OLUploadController alloc] init];
    
    [target handleServerResponse:"{bob:1}"];
    
    [[CPNotificationCenter defaultCenter] verifyThatAllExpectationsHaveBeenMet];
}

@end