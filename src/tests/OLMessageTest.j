@import "../Models/OLMessage.j"

@implementation OLMessageTest : OJTestCase

- (void)testThatOLMessageDoesInitialize
{
    [self assertNotNull:[[OLMessage alloc] init]];
}

- (void)testThatOLMessageDoesInitializeWithDefaultParameters
{
    [self assertNotNull:[[OLMessage alloc] initWithUserID:@"userID" subject:@"subject" content:@"content" to:@"anotherUserId"]];
}

- (void)testThatOLMessageDoesInitializeWithShortParameters
{
    [self assertNotNull:[[OLMessage alloc] initWithUserID:@"userID" to:@"anotherUserId"]];
}

- (void)testThatOLMessageDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageFromUserIDKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageSubjectKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageContentKey"]];
    
    var target = [[OLMessage alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end