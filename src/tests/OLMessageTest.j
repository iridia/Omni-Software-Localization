@import "../Models/OLMessage.j"

@implementation OLMessageTest : OJTestCase
{
    OLUser mockFromUser;
    OLUser mockToUser;
}

- (void)setUp
{
    var mockFromUser = moq();
    var mockToUser = moq();
    
    [mockFromUser selector:@selector(userIdentifier) returns:@"12345"];
    [mockFromUser selector:@selector(email) returns:@"email@email.com"];
    [mockToUser selector:@selector(userIdentifier) returns:@"54321"];
}

- (void)testThatOLMessageDoesInitialize
{
    [self assertNotNull:[[OLMessage alloc] init]];
}

- (void)testThatOLMessageDoesInitializeWithDefaultParameters
{    
    var target = [[OLMessage alloc] initFromUser:mockFromUser toUsers:[mockToUser] subject:@"subject" content:@"content"];
    
    [self assertNotNull:target];
    [self assert:@"email@email.com" equals:[target fromUserEmail]];
    [self assertTrue:[[mockToUser] isEqualToArray:[target toUsers]]];
    [self assert:@"subject" equals:[target subject]];
    [self assert:@"content" equals:[target content]];
}

- (void)testThatOLMessageDoesInitializeWithShortParameters
{
    var target = [[OLMessage alloc] initFromUser:mockFromUser toUsers:[mockToUser]];
    
    [self assertNotNull:target];
    [self assert:@"email@email.com" equals:[target fromUserEmail]];
    [self assertTrue:[[mockToUser] isEqualToArray:[target toUsers]]];
}

- (void)testThatOLMessageDoesInitWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageSubjectKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageContentKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageFromUserEmailKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageDateSentKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageToUsersKey"]];
    
    var target = [[OLMessage alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end