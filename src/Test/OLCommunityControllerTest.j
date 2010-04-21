[CPApplication sharedApplication];

@implementation OLCommunityControllerTest : OJTestCase

- (void)testThatOLCommunityControllerDoesInitialize
{
    [self assertNotNull:[[OLCommunityController alloc] init]];
}

@end