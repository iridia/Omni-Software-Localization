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
    var target = [[OLMessage alloc] initFromUser:mockFromUser toUser:mockToUser subject:@"subject" content:@"content"];
    
    [self assertNotNull:target];
    [self assert:@"12345" equals:[target fromUserID]];
    [self assert:@"email@email.com" equals:[target fromUserEmail]];
    [self assert:@"54321" equals:[target toUserID]];
    [self assert:@"subject" equals:[target subject]];
    [self assert:@"content" equals:[target content]];
}

- (void)testThatOLMessageDoesInitializeWithShortParameters
{
    var target = [[OLMessage alloc] initFromUser:mockFromUser toUser:mockToUser]
    [self assertNotNull:target];
    [self assert:@"12345" equals:[target fromUserID]];
    [self assert:@"email@email.com" equals:[target fromUserEmail]];
    [self assert:@"54321" equals:[target toUserID]];
}

- (void)testThatOLMessageDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageFromUserIDKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageSubjectKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageContentKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageFromUserEmailKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageDateSentKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageToUserIDKey"]];
    
    var target = [[OLMessage alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end