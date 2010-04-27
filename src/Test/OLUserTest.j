@import <OJMoq/OJMoq.j>
@import "../Models/OLUser.j"

@implementation OLUserTest : OJTestCase
{
	OLUser   target;
	OJMoq    mockCoder;
	CPString emailAddress;
}

- (void)setUp
{
	emailAddress = @"me@me.com";
	mockCoder = moq();
	target = [[OLUser alloc] initWithEmail:emailAddress];
}

- (void)testThatOLUserDoesInitialize
{
	var initTarget = [[OLUser alloc] init];
	 
	[self assertNotNull:initTarget];
}

- (void)testThatOLUserDoesInitWithEmail
{
	[self assertNotNull:target];
	[self assert:emailAddress equals:[target email]];
}

- (void)testThatOLUserDoesHaveUserIdentifier
{
    var target = [[OLUser alloc] init];
    [target setRecordID:@"asdf"];
    
    [self assert:@"asdf" equals:[target userIdentifier]];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

- (void)testThatOLUserDoesInitializeWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:emailAddress arguments:[@"OLUserEmailKey"]];
	
	var target = [[OLUser alloc] initWithCoder:coder];

	[self assert:emailAddress equals:[target email]];
}

- (void)testThatOLUserDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[emailAddress, @"OLUserEmailKey"]];
	
	var target = [[OLUser alloc] initWithEmail:emailAddress];
	[target encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end