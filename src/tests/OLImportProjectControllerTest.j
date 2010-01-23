@import "../Controllers/OLImportProjectController.j"


@implementation OLImportProjectControllerTest : OJTestCase

- (void)testThatOLImportProjectControllerDoesInitialize
{
    var target = [[OLImportProjectController alloc] init];
    
    [self assertNotNull:target];
}

- (void)testThatOLImportProjectControllerDoesStartImport
{
    var target = [[OLImportProjectController alloc] init];
    
    var project = moq();
    
    [target startImport:project];
    
    [self assert:project equals:[target project]];
}

@end