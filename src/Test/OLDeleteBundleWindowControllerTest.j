@import "../Views/OLDeleteBundleWindowController.j"

CPApp = [CPApplication sharedApplication];

@implementation OLDeleteBundleWindowControllerTest : OJTestCase

- (void)testThatOLDeleteBundleWindowControllerDoesInitialize
{
    [self assertNotNull:[[OLDeleteBundleWindowController alloc] init]];
}

- (void)testThatOLDeleteBundleWindowControllerDoesHaveDelegate
{
    var target = [[OLDeleteBundleWindowController alloc] init];
    [self assertSettersAndGettersFor:"delegate" on:target];
}

- (void)testThatOLDeleteBundleWindowControllerDoesHaveWindow
{
    var target = [[OLDeleteBundleWindowController alloc] init];
    [self assertSettersAndGettersFor:"window" on:target];
}

- (void)testThatOLDeleteBundleWindowControllerDoesReload
{
    var target = [[OLDeleteBundleWindowController alloc] init];
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