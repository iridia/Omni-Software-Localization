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


@end