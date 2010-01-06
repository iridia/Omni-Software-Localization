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

@end