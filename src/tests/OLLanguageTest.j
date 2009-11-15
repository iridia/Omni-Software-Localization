@import "../Models/OLLanguage.j"

@implementation OLLanguageTest : OJTestCase

- (void)testThatOLLanguageDoesInitialize
{
	var target = [[OLLanguage alloc] init];
	[self assertNotNull:target];
}

@end