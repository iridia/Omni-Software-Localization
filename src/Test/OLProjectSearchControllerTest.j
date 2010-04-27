@import "../Controllers/OLProjectSearchController.j"

var urlConnection = moq();
[OLURLConnectionFactory setConnectionFactoryMethod:function(request, delegate)
{
    return [urlConnection createConnectionWithRequest:request delegate:delegate];
}];

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

- (void)testThatOLProjectSearchControllerDoesSetSearchViewToDefaultView
{
    var target = [[OLProjectSearchController alloc] init];
    
    [self assert:target.searchView equals:[target contentView]];
}

- (void)testThatOLProjectSearchControllerDoesSort
{
    var projectOne = moq();
    var projectTwo = moq();
    
    [projectOne selector:@selector(totalOfAllVotes) returns:1];
    [projectTwo selector:@selector(totalOfAllVotes) returns:2];
    
    var target = [[OLProjectSearchController alloc] init];
    
    target.projects = [projectOne, projectTwo];
    
    [target sortProjects];
    
    [self assert:[projectTwo, projectOne] equals:[target projects]];
}

- (void)testThatOLProjectSearchControllerDoesReturnProjectsMatchingString
{
    var projectOne = moq();
    var projectTwo = moq();

    [projectOne selector:@selector(name) returns:@"One"];
    [projectTwo selector:@selector(name) returns:@"Two"];

    var target = [[OLProjectSearchController alloc] init];

    target.projects = [projectOne, projectTwo];
    
    [target.searchView.searchField setStringValue:@"Tw"];

    [self assert:[projectTwo] equals:[target projectsMatchingString:nil]];
}

- (void)testThatOLProjectSearchControllerDoesDoubleClickTableView
{
    var target = [[OLProjectSearchController alloc] init];
    
    [target didDoubleClickSearchItem:nil];
}

- (void)testThatOLProjectSearchControllerDoesHaveDoubleAction
{
    [self assert:@"tableViewDidDoubleClickItem:" equals:[[[OLProjectSearchController alloc] init] doubleAction]];
}

- (void)testThatOLProjectSearchControllerDoesHandleAlertEnding
{
    [[[OLProjectSearchController alloc] init] alertDidEnd:nil returnCode:0];
}

// uhhh???
// - (void)testThatOLProjectSearchControllerDoesPostNotificationOnBack
// {
//     var target = [[OLProjectSearchController alloc] init];
// 
//     var observer = [[Observer alloc] init];
// 
//     [observer startObserving:OLContentViewControllerShouldUpdateContentView];
// 
//     [target back:nil];
// 
//     [self assertTrue:[observer didObserve:OLContentViewControllerShouldUpdateContentView]];
// }

- (void)testThatOLProjectSearchControllerDoesLoadProjectsWhenGettingDoneNotification
{
    var tempProject = OLProject;

    try
    {
        OLProject = moq();
    
        [OLProject selector:@selector(findAllProjectsByNameWithCallback:) times:1];
    
        var target = [[OLProjectSearchController alloc] init];
        [target didReceiveProjectControllerFinished:nil];
    
        [OLProject verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        OLProject = tempProject;
    }
}

@end