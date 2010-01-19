@import "../Models/OLLanguage.j"
@import <OJMoq/OJMoq.j>

@implementation OLLanguageTest : OJTestCase

- (void)testThatOLLanguageDoesInitialize
{
	var target = [[OLLanguage alloc] init];
	[self assertNotNull:target];
}

- (void)testThatOLLanguageDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLanguageNameKey"]];
    
    var target = [[OLLanguage alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLLanguageDoesEqualItself
{
    var target = [[OLLanguage alloc] initWithName:@"English"];
    
    [self assertTrue:[target equals:target]];
}

- (void)testThatOLLanguageDoesEqualToAnotherWithSameName
{
    var target = [[OLLanguage alloc] initWithName:@"English"];
    var otherLanguage = [[OLLanguage alloc] initWithName:@"English"];
    
    [self assertTrue:[target equals:otherLanguage]];
}

- (void)testThatOLLanguageDoesNotEqualAnotherWithBadName
{
    var target = [[OLLanguage alloc] initWithName:@"English"];
    var otherLanguage = [[OLLanguage alloc] initWithName:@"French"];
    
    [self assertFalse:[target equals:otherLanguage]];
}

- (void)testThatOLLanguageDoesGetEnglishFromLProj
{
    var target = [OLLanguage languageFromLProj:@"English.lproj"];
    [self assertTrue:[target equals:[OLLanguage english]]];
}

- (void)testThatOLLanguageDoesGetFrenchFromLProj
{
    var target = [OLLanguage languageFromLProj:@"French.lproj"];
    [self assertTrue:[target equals:[OLLanguage french]]];
}

- (void)testThatOLLanguageDoesGetSpanishFromLProj
{
    var target = [OLLanguage languageFromLProj:@"Spanish.lproj"];
    [self assertTrue:[target equals:[OLLanguage spanish]]];
}

- (void)testThatOLLanguageDoesGetGermanFromLProj
{
    var target = [OLLanguage languageFromLProj:@"German.lproj"];
    [self assertTrue:[target equals:[OLLanguage german]]];
}

- (void)testThatOLLanguageDoesGetArabicFromLProj
{
    var target = [OLLanguage languageFromLProj:@"ar.lproj"];
    [self assertTrue:[target equals:[OLLanguage arabic]]];
}

- (void)testThatOLLanguageDoesGetJapaneseFromLProj
{
    var target = [OLLanguage languageFromLProj:@"Japanese.lproj"];
    [self assertTrue:[target equals:[OLLanguage japanese]]];
}

- (void)testThatOLLanguageDoesGetAsdfFromLProj
{
    var target = [OLLanguage languageFromLProj:@"asdf.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:"asdf"]]];
}

- (void)testThatOLLanguageDoesClone
{
    var target = [OLLanguage english];
    [self assert:[target clone] notSame:target];
}

- (void)testThatOLLanguageDoesCloneName
{
    var target = [OLLanguage spanish];
    [self assert:[[target clone] name] equals:[target name]];
}

@end