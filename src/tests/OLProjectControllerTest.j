@import "../Controllers/OLProjectController.j"
@import "utilities/CPNotificationCenter+MockDefaultCenter.j"
@import "utilities/OLUserSessionManager+Testing.j"

@implementation OLProjectControllerTest : OJTestCase

- (void)setUp
{
    [CPNotificationCenter setIsMocked:NO];
    [CPNotificationCenter reset];
}

- (void)testThatOLProjectControllerDoesInitialize
{
    [self assertNotNull:[[OLProjectController alloc] init]];
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
    [CPNotificationCenter setIsMocked:YES];
}

@end