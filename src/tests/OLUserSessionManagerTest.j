@import "../Utilities/OLUserSessionManager.j"

@implementation OLUserSessionManagerTest : OJTestCase

- (void)testThatOLUserSessionManagerDoesInitialize
{
    [self assertNotNull:[[OLUserSessionManager alloc] init]];
}

@end