@import "../models/OLLanguage.j"

@implementation OLLanguageTest : OJTestCase

- (void)testThatOLLanguageLoads
{
	[self assertNotNull:[[OLLanguage alloc] initWithName:@"Temp"]];
}

- (void)testThatOLLanguageDoesSetNameCorrectly
{
	var target = [[OLLanguage alloc] initWithName:@"Temp"];
	[self assert:[target name] equals:@"Temp"];
}

- (void)testThatOLLanguageDoesCreateEnglishLanguage
{
	[self assert:[[OLLanguage english] name] equals:@"English"];
}

@end