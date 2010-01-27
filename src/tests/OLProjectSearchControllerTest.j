@import "../Controllers/OLProjectSearchController.j"

@implementation OLProjectSearchControllerTest : OJTestCase

- (void)testThatOLProjectSearchControllerDoesInitialize
{
    [self assertNotNull:[[OLProjectSearchController alloc] init]];
}

- (void)testThatOLProjectSearchControllerDoesLoadProjects
{
    var tempProject = OLProject;
    
    try
    {
        OLProject = moq();
        
        [OLProject selector:@selector(findAllProjectsByNameWithCallback:) times:1];
        
        var target = [[OLProjectSearchController alloc] init];
        [target loadProjects];
        
        [OLProject verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        OLProject = tempProject;
    }
}

@end