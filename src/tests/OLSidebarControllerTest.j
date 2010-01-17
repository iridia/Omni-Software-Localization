@import "../Controllers/OLSidebarController.j"
@import <OJMoq/OJMoq.j>

@implementation OLSidebarControllerTest : OJTestCase

- (void)testThatOLSidebarControllerDoesInitialize
{
    var target = [[OLSidebarController alloc] init];
    [self assertNotNull:target];
}


- (void)testThatOLSidebarControllerDoesAwakeFromCib
{
    var target = [[OLSidebarController alloc] init];
    
    // This hack is to make it pass, otherwise we will be trying to init with a nil frame
    // and since it is a javascript object, it won't be accessed like a CPObject, and throw
    // errors.
    target.sidebarScrollView = moq();
    [target.sidebarScrollView selector:@selector(bounds) returns:CGRectMakeZero()];
    
    [target awakeFromCib];
    
    [self assertTrue:YES];
}

@end