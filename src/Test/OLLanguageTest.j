@import "../Models/OLLanguage.j"
@import <OJMoq/OJMoq.j>

@implementation OLLanguageTest : OJTestCase
{
    JSObject    testParams;
}

- (void)setUp
{
    testParams = {
        "name": "Bulgarian",
        "languageCode": "bg_BG"
    };
}

- (void)testThatOLLanguageDoesInitialize
{
	var target = [[OLLanguage alloc] initWithName:testParams.name];
	[self assertNotNull:target];
	[self assert:testParams.name equals:[target name]];
	[self assert:testParams.languageCode equals:[target languageCode]];
}

- (void)testThatOLLanguageDoesInitWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.name arguments:[@"OLLanguageNameKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.languageCode arguments:[@"OLLanguageLanguageCodeKey"]];
	
	var target = [[OLLanguage alloc] initWithCoder:coder];

	[self assert:testParams.name equals:[target name]];
	[self assert:testParams.languageCode equals:[target languageCode]];
}

- (void)testThatOLFeedbackDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.name, @"OLLanguageNameKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.languageCode, @"OLLanguageLanguageCodeKey"]];
	
	var target = [[OLLanguage alloc] initWithName:testParams.name];
	[target encodeWithCoder:coder];
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
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:@"English (United States)"]]];
}

- (void)testThatOLLanguageDoesGetFrenchFromLProj
{
    var target = [OLLanguage languageFromLProj:@"French.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:@"French (France)"]]];
}

- (void)testThatOLLanguageDoesGetSpanishFromLProj
{
    var target = [OLLanguage languageFromLProj:@"Spanish.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:@"Spanish (Spain)"]]];
}

- (void)testThatOLLanguageDoesGetGermanFromLProj
{
    var target = [OLLanguage languageFromLProj:@"German.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:@"German (Germany)"]]];
}

- (void)testThatOLLanguageDoesGetArabicFromLProj
{
    var target = [OLLanguage languageFromLProj:@"Arabic.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:@"Arabic"]]];
}

- (void)testThatOLLanguageDoesGetJapaneseFromLProj
{
    var target = [OLLanguage languageFromLProj:@"Japanese.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:@"Japanese"]]];
}

- (void)testThatOLLanguageDoesGetAsdfFromLProj
{
    var target = [OLLanguage languageFromLProj:@"asdf.lproj"];
    [self assertTrue:[target equals:[[OLLanguage alloc] initWithName:"asdf"]]];
}

- (void)testThatOLLanguageDoesClone
{
    var target = [[OLLanguage alloc] initWithName:@"English (United States)"];
    [self assert:[target clone] notSame:target];
}

- (void)testThatOLLanguageDoesCloneName
{
    var target = [[OLLanguage alloc] initWithName:@"Spanish (Spain)"];
    [self assert:[[target clone] name] equals:[target name]];
}

@end