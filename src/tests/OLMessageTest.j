@import "../Models/OLMessage.j"

@implementation OLMessageTest : OJTestCase

- (void)testThatOLMessageDoesInitialize
{
    [self assertNotNull:[[OLMessage alloc] init]];
}

- (void)testThatOLMessageDoesInitializeWithDefaultParameters
{
    [self assertNotNull:[[OLMessage alloc] initFromUser:moq() toUser:moq() subject:@"A Message" content:@"content"]];
}

- (void)testThatOLMessageDoesInitializeWithShortParameters
{
    [self assertNotNull:[[OLMessage alloc] initFromUser:moq() toUser:moq()]];
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