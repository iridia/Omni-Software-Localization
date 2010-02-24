@implementation AppControllerTest : OJTestCase

- (void)testThatAppControllerDoesInitialize
{
    var appController = [[AppController alloc] init];
    [self assertNotNull:appController];
}

@end