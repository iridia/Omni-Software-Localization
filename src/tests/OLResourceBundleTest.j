@import "../Models/OLResourceBundle.j"

@implementation OLResourceBundleTest : OJTestCase

- (void)testThatOLResourceBundleDoesInitialize
{
    [self assertNotNull:[[OLResourceBundle alloc] init]];
}

- (void)testThatOLResourceBundleDoesInitializeWithDefaultParameters
{
    [self assertNotNull:[[OLResourceBundle alloc] initWithResources:[CPArray array] language:[OLLanguage english]]];
}

- (void)testThatOLResourceBundleDoesInitalizeWithLanguageOnly
{
    [self assertNotNull:[[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]]];
}

- (void)testThatOLResourceBundleDoesInsertObjectsInResources
{
    var target = [[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]];
    var resource = moq();
    
    [target insertObject:resource inResourcesAtIndex:0];
    
    [self assert:resource equals:[[target resources] objectAtIndex:0]];
}

- (void)testThatOLResourceBundleDoesReplaceObjectsInResources
{
    var target = [[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]];
    var resource = moq();
    var replacementResource = moq();

    [target insertObject:resource inResourcesAtIndex:0];
    [target replaceObjectInResourcesAtIndex:0 withObject:replacementResource];

    [self assert:replacementResource equals:[[target resources] objectAtIndex:0]];
}

- (void)testThatOLResourceBundleDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLResourceBundleLanguageKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLResourceBundleResourcesKey"]];
    
    var target = [[OLResourceBundle alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end