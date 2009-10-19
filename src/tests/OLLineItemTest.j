@import "../models/OLLineItem.j"

@implementation OLLineItemTest : OJTestCase

- (void)testThatOLLineItemLoads
{
	[self assertNotNull:[[OLLineItem alloc] initWithIdentifier:@"Key" withValue:@"Value"]];
}

@end