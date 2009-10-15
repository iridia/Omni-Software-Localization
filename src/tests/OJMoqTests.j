@import "utilities/OJMoq.j"

@implementation OJMoqTests : OJTestCase

- (void)testThatBaseObjectIsSet
{
	var testString = @"Test";
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[self assert:testString equals:[moq object]];
}

- (void)testThatOJMoqDoesRespondToClassConstructor
{
	var testString = @"Test";
	var moq = [OJMoq mockBaseObject:@"Test"];
	[self assert:testString equals:[moq object]];
}


- (void)testThatMoqRespondsToSelector
{
	var testString = @"Test";
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[self assertNotNull:[moq compare:@"Temp"]];
}

- (void)testThatExpectationsAreVerified
{
	var testString = @"Test";
	var sel = @selector(compare:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:1];
	[moq compare:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatExpectationsAreVerifiedWhenMultipleCallsAreInvolved
{
	var testString = @"Test";
	var sel = @selector(compare:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:3];
	[moq compare:@"Temp"];
	[moq compare:@"Temp"];
	[moq compare:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];	
}

- (void)testThatExpectationsAreVerifiedWhenMultipleSelectorsAreInvolved
{
	var testString = @"Test";
	var sel = @selector(compare:);
	var sel2 = @selector(hasPrefix:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:1];
	[moq expectThatSelector:sel2 isCalled:1];
	[moq compare:@"Temp"];
	[moq hasPrefix:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];		
}

- (void)testThatExpectationsFailWhenCalledMoreThanDesired
{
	var testString = @"Test";
	var sel = @selector(compare:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:2];
	[moq compare:@"Temp"];
	[moq compare:@"Temp"];
	[moq compare:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatExpectationsFailWhenCalledLessThanDesired
{
	var testString = @"Test";
	var sel = @selector(compare:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:3];
	[moq compare:@"Temp"];
	[moq compare:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];
}

@end
