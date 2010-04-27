@import "../Views/OLCreateBundleWindowController.j"

CPApp = [CPApplication sharedApplication];

@implementation OLCreateBundleWindowControllerTest : OJTestCase

- (void)testThatOLCreateBundleWindowControllerDoesInitialize
{
    [self assertNotNull:[[OLCreateBundleWindowController alloc] init]];
}

- (void)testThatOLCreateBundleWindowControllerDoesHaveDelegate
{
    var target = [[OLCreateBundleWindowController alloc] init];
    [self assertSettersAndGettersFor:"delegate" on:target];
}

- (void)testThatOLCreateBundleWindowControllerDoesHaveWindow
{
    var target = [[OLCreateBundleWindowController alloc] init];
    [self assertSettersAndGettersFor:"window" on:target];
}

- (void)testThatOLCreateBundleWindowControllerDoesReload
{
    var target = [[OLCreateBundleWindowController alloc] init];
    [target reloadData];
    [self assertTrue:YES];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

@end