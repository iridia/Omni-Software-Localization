@import "../Models/OLProject.j"

@implementation OLProjectTest : OJTestCase

- (void)testThatOLProjectDoesInitialize
{
    [self assertNotNull:[[OLProject alloc] init]];
}

- (void)testThatOLProjectDoesInitializeWithDefaultParameters
{
    [self assertNotNull:[[OLProject alloc] initWithName:@"AProject"]];
}

- (void)testThatOLProjectDoesAddResourceBundleCorrectly
{
    var resourceBundle = moq();
    
    var target = [[OLProject alloc] initWithName:@"AProject"];
    
    [target addResourceBundle:resourceBundle];
    
    [self assert:[resourceBundle resources] equals:[target resources]];
}

- (void)testThatOLProjectDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:["OLProjectNameKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:["OLProjectResourceBundlesKey"]];
    
    var target = [[OLProject alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end