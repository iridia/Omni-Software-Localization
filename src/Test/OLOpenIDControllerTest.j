@import "../Controllers/OLOpenIDController.j"

@implementation OLOpenIDControllerTest : OJTestCase

- (void)setUp
{
    window.open = function(){};
}

- (void)tearDown
{
    window.open = undefined;
}

- (void)testThatOLOpenIDControllerDoesInitialize
{
    [self assertNotNull:[[OLOpenIDController alloc] init]];
}

- (void)testThatOLOpenIDControllerDoesHaveDelegate
{
    var target = [[OLOpenIDController alloc] init];
    
    [self assertSettersAndGettersFor:@"delegate" on:target];
}

- (void)testThatOLOpenIDControllerDoesLoginToGoogle
{
    var target = [[OLOpenIDController alloc] init];
    
    [target loginToGoogle:nil];
    
    [self assertTrue:YES];
}

- (void)testThatOLOpenIDControllerDoesLoginToYahoo
{
    var target = [[OLOpenIDController alloc] init];
    
    [target loginToYahoo:nil];
    
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