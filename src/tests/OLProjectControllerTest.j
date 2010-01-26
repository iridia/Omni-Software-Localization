@import "../Controllers/OLProjectController.j"
@import "utilities/OLUserSessionManager+Testing.j"

@implementation OLProjectControllerTest : OJTestCase

- (void)testThatOLProjectControllerDoesInitialize
{
    [self assertNotNull:[[OLProjectController alloc] init]];
}

- (void)testThatOLProjectControllerDoesLoadProjects
{
    var user = moq();
    [user selector:@selector(userIdentifier) returns:@"12345"];
    [[OLUserSessionManager defaultSessionManager] setUser:user];
    
    var tempProject = OLProject;
    try
    {
        OLProject = moq();
    
        [OLProject selector:@selector(findByUserIdentifier:callback:) times:1];
    
        var target = [[OLProjectController alloc] init];
    
        [target loadProjects];
    
        [OLProject verifyThatAllExpectationsHaveBeenMet];
    } 
    finally 
    {
        OLProject = tempProject;
    }
}

- (void)testThatOLProjectControllerDoesAddProjects
{
    var project = moq();
    
    var target = [[OLProjectController alloc] init];
    
    [target insertObject:project inProjectsAtIndex:0];
    
    [self assert:project equals:[[target projects] objectAtIndex:0]];
}

- (void)testThatOLProjectControllerDoesAddProjectsAlternateAPI
{
    var project = moq();

    var target = [[OLProjectController alloc] init];

    [target addProject:project];

    [self assert:project equals:[[target projects] objectAtIndex:0]];
}

- (void)tearDown
{
    [OLUserSessionManager resetDefaultSessionManager];
}

@end