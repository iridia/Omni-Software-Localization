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

- (void)testThatOLProjectControllerDoesLoadProjects
{
    var user = moq();
    [user selector:@selector(userIdentifier) returns:@"12345"];
    [[OLUserSessionManager defaultSessionManager] setUser:user];
    
    var tempProject = OLProject;
    try
    {
        OLProject = moq();
    
        [OLProject selector:@selector(findByUserIdentifier:withCallback:) times:1];
    
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

- (void)testThatOLProjectControllerDoesRegisterForImportNotification
{
    var target = [[OLProjectController alloc] init];
      
    [self assert:target registered:@"OLProjectShouldImportNotification"]
}

- (void)testThatOLProjectControllerDoesRespondToStartImport
{
    var target = [[OLProjectController alloc] init];
    
    [target startImport:moq()];
    [self assertTrue:YES];
}

- (void)tearDown
{
    [OLUserSessionManager resetDefaultSessionManager];
    [CPNotificationCenter setIsMocked:YES];
}

- (void)assert:(id)target registered:(CPString)aNotification
{
    var names = [[CPNotificationCenter defaultCenter]._namedRegistries keyEnumerator];
    
    while (name = [names nextObject])
    {
        if([name isEqualToString:aNotification])
        {
            var registry = [[CPNotificationCenter defaultCenter]._namedRegistries objectForKey:name];
            var objects = [registry._objectObservers keyEnumerator];
            while(object = [objects nextObject])
            {
                var observers = [registry._objectObservers objectForKey:object];
                for(var i = 0; i < [observers count]; i++)
                {
                    if(target === [observers[i] observer])
                    {
                        return;
                    }
                }
            }
        }
    }
    
    [self fail:@"Target <"+[target description]+"> was not registered with <"+aNotification+">"];
}

@end