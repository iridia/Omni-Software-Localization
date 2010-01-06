@implementation OLLineItemTest : OJTestCase

- (void)testThatOLLineItemDoesInitialize
{
    [self assertNotNull:[[OLLineItem alloc] init]];
}

- (void)testThatOLLineItemDoesInitializeWithDefaultParameters
{
    [self assertNotNull:[[OLLineItem alloc] initWithIdentifier:@"id" value:@"value" comment:@"comment"]];
}

- (void)testThatOLLineItemDoesInitializeWithShortParameters
{
    [self assertNotNull:[[OLLineItem alloc] initWithIdentifier:@"id" value:@"value"]];
}

- (void)testThatOLLineItemDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemCommentKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemIdentifierKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemValueKey"]];
    
    var target = [[OLLineItem alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end