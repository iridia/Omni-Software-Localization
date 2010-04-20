@import <AppKit/AppKit.j>
@import <OJMoq/OJMoq.j>
@import "../Controllers/OLToolbarController.j"

CPApp = moq();
CPApp._windows = moq();

@implementation OLToolbarControllerTest : OJTestCase

- (void)testThatOLToolbarControllerTestDoesInitialize
{
	var target = [[OLToolbarController alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLToolbarControllerDoesPostNotificationForNewMessage
{
    var observer = [[Observer alloc] init];

    var target = [[OLToolbarController alloc] init];

    [observer startObserving:@"OLMessageControllerShouldSendMessageNotification"];

    [target newMessage:nil];

    [self assertTrue:[observer didObserve:@"OLMessageControllerShouldSendMessageNotification"]];
}

- (void)testThatOLToolbarControllerDoesPostNotificationForLogin
{
    var observer = [[Observer alloc] init];

    var target = [[OLToolbarController alloc] init];

    [observer startObserving:@"OLLoginControllerShouldLoginNotification"];

    [target login:nil];

    [self assertTrue:[observer didObserve:@"OLLoginControllerShouldLoginNotification"]];
}

- (void)testThatOLToolbarControllerDoesPostNotificationForLogout
{
    var observer = [[Observer alloc] init];

    var target = [[OLToolbarController alloc] init];

    [observer startObserving:@"OLLoginControllerShouldLogoutNotification"];

    [target logout:nil];

    [self assertTrue:[observer didObserve:@"OLLoginControllerShouldLogoutNotification"]];
}

- (void)testThatOLToolbarControllerDoesHaveToolbar
{
    var target = [[OLToolbarController alloc] init];
    
    [self assertSettersAndGettersFor:@"toolbar" on:target];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

@end