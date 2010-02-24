@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import "../AppController.j"

@implementation AppControllerTest : OJTestCase

- (void)testThatAppControllerDoesInitialize
{
    var appController = [[AppController alloc] init];
    [self assertNotNull:appController];
}

@end