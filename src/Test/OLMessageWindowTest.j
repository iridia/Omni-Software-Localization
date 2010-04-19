@import "../Views/OLMessageWindow.j"

@implementation OLMessageWindowTest : OJTestCase

- (void)testThatOLMessageWindowDoesInitialize
{
    [self assertNotNull:[[OLMessageWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask]];
}

- (void)testThatOLMessageWindowDoesHaveDelegate
{
    var target = [[OLMessageWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask];
    
    [self assertSettersAndGettersFor:"delegate" on:target];
}

- (void)testThatOLMessageWindowDoesSendBroadcastMessage
{
    var target = [[OLMessageWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask];
    var delegate = moq([[OLMessageController alloc] init]);
    
    [delegate selector:@selector(didSendBroadcastMessage:) times:1];
    
    [target setDelegate:delegate];
    [target sendBroadcastMessage:nil];
    
    [delegate verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLMessageWindowDoesSendMessage
{
    var target = [[OLMessageWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPTitledWindowMask];
    var delegate = moq([[OLMessageController alloc] init]);

    [delegate selector:@selector(didSendMessage:) times:1];

    [target setDelegate:delegate];
    [target sendMessage:nil];

    [delegate verifyThatAllExpectationsHaveBeenMet];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

@end