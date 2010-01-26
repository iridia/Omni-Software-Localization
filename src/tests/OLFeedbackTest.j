@import "../Models/OLFeedback.j"
@import <OJMoq/OJMoq.j>

@implementation OLFeedbackTest : OJTestCase

- (void)testThatOLFeedbackDoesInitialize
{
	var target = [[OLFeedback alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLFeedbackDoesInitializeWithEmailNameAndType
{
	var target = [[OLFeedback alloc] initWithEmail:@"anEmail" type:@"aType" text:@"someText"];
	[self assertNotNull:target];
}

- (void)testThatOLFeedbackDoesInitializeWithCoder
{
	var target = [[OLFeedback alloc] initWithCoder:moq()];
	[self assertNotNull:target];
}

- (void)testThatOLFeedbackDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[CPArray arrayWithObjects:@"anEmail", @"OLFeedbackEmailKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[CPArray arrayWithObjects:@"aType", @"OLFeedbackTypeKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[CPArray arrayWithObjects:@"someText", @"OLFeedbackTextKey"]];
	
	var target = [[OLFeedback alloc] initWithEmail:@"anEmail" type:@"aType" text:@"someText"];
	
	[target encodeWithCoder:coder];
	
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end