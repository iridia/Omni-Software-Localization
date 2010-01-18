@import <Foundation/CPUserSessionManager.j>

@import "../Controllers/OLProjectController.j"

@implementation OLProjectControllerTest : OJTestCase

- (void)testThatOLProjectControllerDoesInitialize
{
    [self assertNotNull:[[OLProjectController alloc] init]];
}

- (void)testThatOLProjectControllerDoesLoadProjects
{
    var tempProject = OLProject;
    try
    {
        OLProject = moq();
    
        [OLProject expectSelector:@selector(listWithCallback:) times:1];
    
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

- (void)testThatOLProjectControllerDoesAddSubscribersWhenBranching
{
    var CPAlertTemp = CPAlert;
    try
    {
        CPAlert = moq();
        
        [CPAlert selector:@selector(alloc) returns:CPAlert];
        [CPAlert selector:@selector(init) returns:CPAlert];
    
        var project = moq();
        [project expectSelector:@selector(addSubscriber:) times:1];
    
        var target = [[OLProjectController alloc] init];
    
        target.selectedProject = project;
    
        [target didReceiveProjectShouldBranchNotification:moq()];
    
        [project verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        CPAlert = CPAlertTemp;
    }
}

@end