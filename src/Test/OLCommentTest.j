@import "../Models/OLComment.j"

@implementation OLCommentTest : OJTestCase



- (void)testThatOLCommentDoesInitialize
{
    [self assertNotNull:[[OLComment alloc] init]];
}

- (void)testThatOLCommentDoesInitializeWithUserAndContent
{
    var user = [[OLUser alloc] initWithEmail:@"Test"];
    [self assertNotNull:[[OLComment alloc]
        initFromUser:user withContent:"Test Message"]];
}

- (void)testThatOLCommentDoesHaveContent
{
    var user = [[OLUser alloc] initWithEmail:@"Test"];
    var target = [[OLComment alloc] initFromUser:user withContent:@"Test Message"];
    
    [self assertSettersAndGettersFor:"content" on:target];
}

- (void)testThatOLCommentDoesHaveUserID
{
    var user = [[OLUser alloc] initWithEmail:@"Test"];
    var target = [[OLComment alloc] initFromUser:user withContent:@"Test Message"];

    [self assertSettersAndGettersFor:"userID" on:target];
}

- (void)testThatOLCommentDoesHaveUserEmail
{
    var user = [[OLUser alloc] initWithEmail:@"Test"];
    var target = [[OLComment alloc] initFromUser:user withContent:@"Test Message"];

    [self assertSettersAndGettersFor:"userEmail" on:target];
}

- (void)testThatOLCommentDoesHaveDate
{
    var user = [[OLUser alloc] initWithEmail:@"Test"];
    var target = [[OLComment alloc] initFromUser:user withContent:@"Test Message"];

    [self assertSettersAndGettersFor:"date" on:target];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";
    
    [object performSelector:setter withObject:value];
    
    [self assert:value equals:[object performSelector:name]];
}

@end