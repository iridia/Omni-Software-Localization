@import <OJMoq/OJMoq.j>
@import "../Models/OLUser.j"

var OLUserEmailKey = @"OLUserEmailKey";

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


- (void)testThatOLUserDoesEncodeData
{	
	[mockCoder selector:@selector(encodeObject:forKey:) times:1
		arguments:[emailAddress, OLUserEmailKey]];
		
	[target encodeWithCoder:mockCoder];
	
	[mockCoder verifyThatAllExpectationsHaveBeenMet];
}


- (void)testThatOLUserDoesInitWithCoder
{
    [mockCoder selector:@selector(decodeObjectForKey:) times:1 arguments:[OLUserEmailKey]];
	[mockCoder selector:@selector(decodeObjectForKey:) returns:emailAddress arguments:[OLUserEmailKey]];
	
	var encodeTarget = [[OLUser alloc] initWithCoder:mockCoder];
	
	[mockCoder verifyThatAllExpectationsHaveBeenMet];
	
	[self assertNotNull:encodeTarget];
	[self assert:emailAddress equals:[encodeTarget email]];
}


- (void)testThatOLUserDoesInitWithEmail
{
	[self assertNotNull:target];
	[self assert:emailAddress equals:[target email]];
}

- (void)testThatOLUserDoesHaveNickname
{
    var target = [[OLUser alloc] init];
    
    [self assertSettersAndGettersFor:@"nickname" on:target];
}

- (void)testThatOLUserDoesHaveUserLocation
{
    var target = [[OLUser alloc] init];
    
    [self assertSettersAndGettersFor:@"userLocation" on:target];
}

- (void)testThatOLUserDoesHaveLanguages
{
    var target = [[OLUser alloc] init];
    
    [self assertSettersAndGettersFor:@"languages" on:target];
}

- (void)testThatOLUserDoesHaveBio
{
    var target = [[OLUser alloc] init];
    
    [self assertSettersAndGettersFor:@"bio" on:target];
}

- (void)testThatOLUserDoesHaveUserIdentifier
{
    var target = [[OLUser alloc] init];
    [target setRecordID:@"asdf"];
    
    [self assert:@"asdf" equals:[target userIdentifier]];
}

- (void)testThatOLUserDoesMatchTrueEqualityOnEmail
{
    var target = [[OLUser alloc] initWithEmail:@"user@email.com"];
    
    [self assertTrue:[target emailIsEqualToString:@"user@email.com"]];
}

- (void)testThatOLUserDoesMatchFalseEqualityOnEmail
{
    var target = [[OLUser alloc] initWithEmail:@"user@email.com"];
    
    [self assertFalse:[target emailIsEqualToString:@"userA@email.com"]];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

@end