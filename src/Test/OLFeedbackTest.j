@import "../Models/OLFeedback.j"
@import <OJMoq/OJMoq.j>

@implementation OLFeedbackTest : OJTestCase
{
    JSObject    testParams;
}

- (void)setUp
{
    testParams = {
        "email": "anEmail",
        "type": "aType",
        "text": "someText"
    };
}

- (void)testThatOLFeedbackDoesInitialize
{
	var target = [[OLFeedback alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLFeedbackDoesInitializeWithEmailNameAndType
{
	var target = [[OLFeedback alloc] initWithEmail:testParams.email type:testParams.type text:testParams.text];
	
	[self assertNotNull:target];
	[self assert:testParams.email equals:[target email]];
	[self assert:testParams.type equals:[target type]];
	[self assert:testParams.text equals:[target text]];
}

- (void)testThatOLFeedbackDoesInitializeWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.email arguments:[@"OLFeedbackEmailKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.type arguments:[@"OLFeedbackTypeKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.text arguments:[@"OLFeedbackTextKey"]];
	
	var target = [[OLFeedback alloc] initWithCoder:coder];

	[self assert:testParams.email equals:[target email]];
	[self assert:testParams.type equals:[target type]];
	[self assert:testParams.text equals:[target text]];
}

- (void)testThatOLFeedbackDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.email, @"OLFeedbackEmailKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.type, @"OLFeedbackTypeKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.text, @"OLFeedbackTextKey"]];
	
	var target = [[OLFeedback alloc] initWithEmail:testParams.email type:testParams.type text:testParams.text];
	[target encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end