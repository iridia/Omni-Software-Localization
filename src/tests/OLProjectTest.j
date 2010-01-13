@import "../Models/OLProject.j"

@implementation OLProjectTest : OJTestCase

- (void)testThatOLProjectDoesInitialize
{
    var target = [[OLProject alloc] init];
    [self assertNotNull:target];
}

- (void)testThatOLProjectDoesInitializeWithName
{
    var projectName = @"AProject";
    var target = [[OLProject alloc] initWithName:projectName];
    
    [self assertNotNull:target];
    [self assert:projectName equals:[target name]];
    [self assertTrue:[[CPArray array] isEqualToArray:[target resourceBundles]]];
}

- (void)testThatOLProjectDoesInitializeWithNameAndUserIdentifier
{
    var userID = @"1234";
    var target = [[OLProject alloc] initWithName:@"AProject" userIdentifier:userID];
    
    [self assertNotNull:target];
    [self assert:userID equals:[target userIdentifier]];
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