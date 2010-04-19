@implementation OLMessageControllerTest : OJTestCase

- (void)testThatOLMessageControllerDoesInitialize
{
    [self assertNotNull:[[OLMessageController alloc] init]];
}

- (void)testThatOLMessageControllerDoesCreateBroadcastMessage
{
    var target = [[OLMessageController alloc] init];
    var notification = [[CPNotification alloc] initWithName:@"Test" object:moq() userInfo:moq()];
    
    [target createBroadcastMessage:notification];
    
    [self assertTrue:[target.messageWindow.emailLabel isHidden]];
}

@end