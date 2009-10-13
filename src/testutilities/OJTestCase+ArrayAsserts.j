/*!
 * Category that adds array asserts to OJTestCase.
 */
@implementation OJTestCase (ArrayAsserts)

- (void)assert:(CPArray)anArray doesNotContain:(CPObject)anObject
{
	[self assert:anArray doesNotContain:anObject message:@"Array contains object " + [anObject description]];
}

- (void)assert:(CPArray)anArray doesNotContain:(CPObject)anObject message:(CPString)failMessage
{
	if([anArray contains:anObject])
	{
		[self fail:failMessage];
	}
}

- (void)assert:(CPArray)anArray contains:(CPObject)anObject
{
	[self assert:anArray contains:anObject message:@"Array does not contain object " + [anObject description]];
}

- (void)assert:(CPArray)anArray contains:(CPObject)anObject message:(CPString)failMessage
{
	if(![anArray contains:anObject])
	{
		[self fail:failMessage];
	}
}

@end