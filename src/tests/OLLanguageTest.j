@import "../Models/OLLanguage.j"

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

- (void)testThatOLLanguageDoesCreateFrenchLanguage
{
	[self assert:[[OLLanguage french] name] equals:@"French"];
}

- (void)testThatOLLanguageDoesCreateSpanishLanguage
{
	[self assert:[[OLLanguage spanish] name] equals:@"Spanish"];
}

- (void)testThatOLLanguageDoesCreateGermanLanguage
{
	[self assert:[[OLLanguage german] name] equals:@"German"];
}

- (void)testThatOLLanguageDoesCreateArabicLanguage
{
	[self assert:[[OLLanguage arabic] name] equals:@"Arabic"];
}

- (void)testThatOLLanguageDoesCreateJapaneseLanguage
{
	[self assert:[[OLLanguage japanese] name] equals:@"Japanese"];
}

@end