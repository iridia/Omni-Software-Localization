@import "../Controllers/OLProjectSearchController.j"

@implementation OLProjectSearchControllerTest : OJTestCase

- (void)setUp
{
    OSL_MAIN_VIEW_FRAME = CGRectMakeZero();
    urlConnection = moq();
    [OLURLConnectionFactory setConnectionFactoryMethod:function(request, delegate)
    {
        return [urlConnection createConnectionWithRequest:request delegate:delegate];
    }];
}

- (void)tearDown
{
    OSL_MAIN_VIEW_FRAME = nil;
    [OLURLConnectionFactory setConnectionFactoryMethod:nil];
}

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

- (void)testThatOLProjectSearchControllerDoesAddSubscribersWhenBranching
{
    var CPAlertTemp = CPAlert;
    try
    {
        CPAlert = moq();

        [CPAlert selector:@selector(alloc) returns:CPAlert];
        [CPAlert selector:@selector(init) returns:CPAlert];

        var project = moq();
        [project selector:@selector(addSubscriber:) times:1];
        [project selector:@selector(clone) returns:moq()];
        [[OLUserSessionManager defaultSessionManager] setUser:moq()];

        var target = [[OLProjectSearchController alloc] init];

        target.selectedProject = project;

        [target alertDidEnd:moq() returnCode:1];

        [project verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        CPAlert = CPAlertTemp;
    }
}

@end