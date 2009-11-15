@import "../Utilities/OLException.j"
@import "utilities/OJMoq/OJMoq.j"
@import <AppKit/AppKit.j>

@implementation OLExceptionTest : OJTestCase

- (void)testThatOLExceptionDoesInitialize
{
	var target = [[OLException alloc] initWithName:@"Test" reason:@"Testing" userInfo:[CPDictionary dictionary]];
	[self assertNotNull:target];
}

- (void)testThatOLExceptionDoesNotThrowJavascriptException
{
	var target = [OLException raise:@"aName" reason:@"aReason"];
	[self assertNotNull:target];
}

- (void)testThatOLExceptionDoesCallSharedApplicationWhenRaising
{
	var mockApp = moq();
	
	[mockApp expectSelector:@selector(delegate) times:1];
	[mockApp selector:@selector(delegate) returns:moq()];
	
	CPApp = mockApp;
	
	var target = [OLException raise:@"aName" reason:@"aReason"];
	
	[mockApp verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLExceptionDoesCallHandleExceptionOnDelegateOfSharedApplication
{
	var mockApp = moq();
	var mockDelegate = moq();

	[mockApp selector:@selector(delegate) returns:mockDelegate];

	CPApp = mockApp;
	
	var target = [OLException raise:@"aName" reason:@"aReason"];
	
	[mockDelegate expectSelector:@selector(handleException:) times:1 arguments:[CPArray arrayWithObject:target]];
	
	[mockDelegate verifyThatAllExpectationsHaveBeenMet];
}

@end