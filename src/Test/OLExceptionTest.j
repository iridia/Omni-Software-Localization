@import "../Utilities/OLException.j"
@import <OJMoq/OJMoq.j>
@import <AppKit/AppKit.j>

@implementation OLExceptionTest : OJTestCase
{
    JSObject    testParams;
    OLException target;
}

- (void)setUp
{
    testParams = {
        "name": "NAME",
        "reason": "REASON",
        "userInfo": [CPDictionary dictionaryWithObjects:[@"1", @"2"] forKeys:[@"One", @"Two"]],
        "errorClass": "CLASS",
        "errorMethod": "METHOD",
        "message": "MESSAGE"
    };
    
    target = [[OLException alloc] initWithName:testParams.name reason:testParams.reason userInfo:testParams.userInfo];
    
    urlConnection = moq();
    [OLURLConnectionFactory setConnectionFactoryMethod:function(request, delegate)
    {
        return [urlConnection createConnectionWithRequest:request delegate:delegate];
    }];
}

- (void)tearDown
{
    [OLURLConnectionFactory setConnectionFactoryMethod:nil];
}

- (void)testThatOLExceptionDoesInitialize
{
	[self assertNotNull:target];
	[self assert:[target name] equals:testParams.name];
	[self assert:[target reason] equals:testParams.reason];
	[self assert:[target userInfo] equals:testParams.userInfo];
}

- (void)testThatOLExceptionDoesAllowSettingInfo
{
    [target setClassWithError:target.errorClass];
    [target setMethodWithError:target.errorMethod];
    [target setUserMessage:target.message];

	[self assert:target.errorClass equals:[target classWithError]];
	[self assert:target.errorMethod equals:[target methodWithError]];
	[self assert:target.message equals:[target userMessage]];
}

- (void)testThatOLExceptionDoesAddInfoForKey
{
    var value = moq();
    [target addUserInfo:value forKey:@"Test"];
    
    [self assert:value equals:[[target userInfo] objectForKey:@"Test"]];
}

- (void)testThatOLExceptionDoesNotThrowJavascriptException
{
	var target = [OLException raise:@"aName" reason:@"aReason"];
	[self assertNotNull:target];
}

- (void)testThatOLExceptionDoesCallSharedApplicationWhenRaising
{
	var mockApp = moq();
	
	[mockApp selector:@selector(delegate) times:1];
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
	
	[mockDelegate selector:@selector(handleException:) times:1 arguments:[CPArray arrayWithObject:target]];
	
	[target raise];
	
	[mockDelegate verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLExceptionDoesInitializeWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.errorClass arguments:[@"OLExceptionClassKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.errorMethod arguments:[@"OLExceptionMethodKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.message arguments:[@"OLExceptionUserMessageKey"]];
	
	var target = [[OLException alloc] initWithCoder:coder];

	[self assert:testParams.errorClass equals:[target classWithError]];
	[self assert:testParams.errorMethod equals:[target methodWithError]];
	[self assert:testParams.message equals:[target userMessage]];
}

- (void)testThatOLFeedbackDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.errorClass, @"OLExceptionClassKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.errorMethod, @"OLExceptionMethodKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.message, @"OLExceptionUserMessageKey"]];
	
	[target setClassWithError:testParams.errorClass];
	[target setMethodWithError:testParams.errorMethod];
	[target setUserMessage:testParams.message];
	
	[target encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end