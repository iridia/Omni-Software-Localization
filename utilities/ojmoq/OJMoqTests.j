@import <Foundation/CPObject.J>
@import "[OJMoq alloc].j"

@implementation OJMoqTests : OJTestCase

- (void)testThatBaseObjectIsSet
{
	var testString = @"Test";
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[self assert:[testString equals:[moq object]]];
}

- (void)testThatMoqRespondsToSelector
{
	var testString = @"Test";
	var sel = @selector(stringByAppendingString:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[self assert:[moq sel:@"Temp"]];
}

- (void)testThatExpectationsAreVerified
{
	var testString = @"Test";
	var sel = @selector(stringByAppendingString:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:1];
	[moq sel:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatExpectationsAreVerifiedWhenMultipleCallsAreInvolved
{
	var testString = @"Test";
	var sel = @selector(stringByAppendingString:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:3];
	[moq sel:@"Temp"];
	[moq sel:@"Temp"];
	[moq sel:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];	
}

- (void)testThatExpectationsAreVerifiedWhenMultipleSelectorsAreInvolved
{
	var testString = @"Test";
	var sel = @selector(stringByAppendingString:);
	var sel2 = @selector(stringWithString:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:1];
	[moq expectThatSelector:sel2 isCalled:1];
	[moq sel:@"Temp"];
	[moq sel2:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];		
}

- (void)testThatExpectationsFailWhenCalledMoreThanDesired
{
	var testString = @"Test";
	var sel = @selector(stringByAppendingString:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:2];
	[moq sel:@"Temp"];
	[moq sel:@"Temp"];
	[moq sel:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatExpectationsFailWhenCalledLessThanDesired
{
	var testString = @"Test";
	var sel = @selector(stringByAppendingString:);
	var moq = [[OJMoq alloc] initWithBaseObject:testString];
	[moq expectThatSelector:sel isCalled:3];
	[moq sel:@"Temp"];
	[moq sel:@"Temp"];
	[moq verifyThatAllExpectationsHaveBeenMet];
}

@end
