@implementation OLNotificationTest : OJTestCase

- (void)testThatOLNotificationDoesInitialize
{
    [self assertNotNull:[[OLNotification alloc] init]];
}

- (void)testThatOLNotificationDoesSetNotificationText
{
    var target = [[OLNotification alloc] init];
    
    [target setNotificationText:@"TEST"];
    
    [self assert:@"TEST" equals:[target.notification stringValue]];
}

@end