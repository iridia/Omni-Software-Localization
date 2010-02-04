@import "OLProjectController.j"
@import "../Views/OLProjectDashboardView.j"

@implementation OLMyProjectController : OLProjectController
{
	OLImportProjectController   importProjectController;
	
	CPView                      dashboardView;
	CPView                      containerView;
}

- (id)init
{
    if(self = [super init])
    {
        containerView = [[CPView alloc] initWithFrame:CGRectMakeZero(0, 0, 0, 0)];
        [containerView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        projectView = [[OLProjectView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        [projectView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        dashboardView = [[OLProjectDashboardView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [dashboardView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [dashboardView setDelegate:self];
        
        [containerView addSubview:projectView];
        [containerView addSubview:dashboardView];
        [dashboardView setHidden:YES];
        
        importProjectController = [[OLImportProjectController alloc] init];
   		
   		[self registerForNotifications];
   		
        [projectView setResourcesTableViewDataSource:self];
        [projectView setLineItemsTableViewDataSource:self];
        [projectView setResourcesTableViewDelegate:self];
        [projectView setLineItemsTableViewDelegate:self];
        [projectView setLineItemsTarget:self doubleAction:@selector(lineItemsTableViewDoubleClick:)];
        [projectView setResourceBundleDelegate:self];
        [projectView setVotingDataSource:self];
        [projectView setVotingDelegate:self];
        [projectView setOwnerDataSource:self];
        [projectView setTitleDataSource:self];
    }
    return self;
}

- (void)registerForNotifications
{   
	[[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveParseServerResponseNotification:)
		name:@"OLUploadControllerDidParseServerResponse"
		object:nil];

	[[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
		name:CPOutlineViewSelectionDidChangeNotification
		object:nil];

	[[CPNotificationCenter defaultCenter]
	    addObserver:self
	    selector:@selector(didReceiveProjectDidChangeNotification:)
	    name:@"OLProjectDidChangeNotification"
	    object:nil];

	[[CPNotificationCenter defaultCenter]
	    addObserver:self
	    selector:@selector(loadProjects)
	    name:OLProjectShouldReloadMyProjectsNotification
	    object:nil];

    [[CPNotificationCenter defaultCenter]
	    addObserver:self
		selector:@selector(didReceiveUserDidChangeNotification:)
		name:OLUserSessionManagerUserDidChangeNotification
		object:nil];

	[[CPNotificationCenter defaultCenter]
	   addObserver:self
	   selector:@selector(didReceiveLineItemSelectedIndexDidChangeNotification:)
	   name:OLLineItemSelectedLineItemIndexDidChangeNotification
	   object:[[resourceBundleController resourceController] lineItemController]];

   [[CPNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(startCreateNewBundle:)
       name:@"CPLanguageShouldAddLanguageNotification"
       object:nil];

   [[CPNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(startDeleteBundle:)
       name:@"CPLanguageShouldDeleteLanguageNotification"
       object:nil];

   [[CPNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(downloadSelectedProject:)
       name:@"OLProjectShouldDownloadNotification"
       object:nil];

    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(createBroadcastMessage:)
        name:@"CPMessageShouldBroadcastNotification"
        object:nil];

    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(startImport:)
        name:@"OLProjectShouldImportNotification"
        object:nil];

    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(didReceiveShouldCreateCommentNotification:)
        name:OLProjectShouldCreateCommentNotification
        object:nil];
}

- (void)startImport:(CPNotification)notification
{
    [importProjectController startImport:selectedProject];
}

- (void)createBroadcastMessage:(CPNotification)notification
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLMessageControllerShouldShowBroadcastViewNotification
        object:self
        userInfo:[CPDictionary dictionaryWithObjects:[selectedProject] forKeys:[@"project"]]];
}

- (void)loadProjects
{
    [self willChangeValueForKey:@"projects"];
    projects = [CPArray array];
    [self didChangeValueForKey:@"projects"];

    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userLoggedIn = [[OLUserSessionManager defaultSessionManager] userIdentifier];
        [OLProject findByUserIdentifier:userLoggedIn withCallback:function(project)
    	{
    	    if (project)
    	    {
                [self addProject:project];
            }
        }];
    }
}

- (void)didReceiveProjectsShouldReloadNotification:(CPNotification)notification
{
    [self loadProjects];
    [self reloadData];
}

- (void)didReceiveShouldCreateCommentNotification:(CPNotification)notification
{
    var options = [notification userInfo];
    var content = [options objectForKey:@"content"];
    var item = [options objectForKey:@"item"];
    var user = [[OLUserSessionManager defaultSessionManager] user];

    var comment = [[OLComment alloc] initFromUser:user withContent:content];
    [item addComment:comment];
    
    [selectedProject save];
}

- (void)didReceiveParseServerResponseNotification:(CPNotification)notification
{
	var jsonResponse = [[notification object] jsonResponse];

	if (jsonResponse.fileType === @"zip")
	{
		var newProject = [OLProject projectFromJSON:jsonResponse];
		[self addProject:newProject];
    	[newProject saveWithCallback:function(){
    	    [[CPNotificationCenter defaultCenter]
                        postNotificationName:OLProjectShouldReloadMyProjectsNotification
                        object:self];
    	}];
	}
}

- (void)didReceiveUserDidChangeNotification:(CPNotification)notification
{
    [self loadProjects];
}

@end

@implementation OLMyProjectController (DataSource)

- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    if (tableView === [projectView resourcesTableView])
    {
        return [resourceBundleController numberOfResources];
    }
    
    if (tableView === [projectView lineItemsTableView])
    {
        return [resourceBundleController numberOfLineItems];
    }

    if (tableView === [[dashboardView subscribers] tableView])
    {
        return [[selectedProject subscribers] count];
    }
    
    if (tableView === [[dashboardView branchesTableView] tableView])
    {
        return 10;
    }
    
    return 30;
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if (tableView === [projectView resourcesTableView])
    {
        return [resourceBundleController resourceNameAtIndex:row];
    }
    
    if (tableView === [projectView lineItemsTableView])
    {
        var lineItem = [resourceBundleController lineItemAtIndex:row];
        
        if ([[tableColumn identifier] isEqualToString:OLLineItemTableColumnIdentifierIdentifier])
        {
            return [lineItem identifier];
        }
        
        if ([[tableColumn identifier] isEqualToString:OLLineItemTableColumnValueIdentifier])
        {
            return [lineItem value];
        }
    }
    
    if (tableView === [[dashboardView subscribers] tableView])
    {
        return [[selectedProject subscribers] objectAtIndex:row];
    }
    
    if (tableView === [[dashboardView branchesTableView] tableView])
    {
        return "A Branch";
    }
}

- (CPString)projectName
{
    return [selectedProject name];
}

- (CPArray)comments
{
    var theUser = [[OLUserSessionManager defaultSessionManager] user];
    return [[[OLComment alloc] initFromUser:theUser withContent:@"Test1"], [[OLComment alloc] initFromUser:theUser withContent:@"Test2"], [[OLComment alloc] initFromUser:theUser withContent:@"Test3"]];
}

- (CPView)contentView
{
    return containerView;
}

- (void)showProjectView
{
    var animation = [[_OLProjectViewAnimation alloc] initWithNewView:projectView oldView:dashboardView];
    [projectView setHidden:NO];
    [projectView setFrameOrigin:CGPointMake([dashboardView bounds].size.width, 0)];
    
    [animation startAnimation];
}

- (void)dashboardWasClicked:(id)sender
{
    var animation = [[_OLProjectViewAnimation alloc] initWithNewView:dashboardView oldView:projectView];
    [dashboardView setHidden:NO];
    [dashboardView setFrameOrigin:CGPointMake(0-[projectView bounds].size.width, 0)];
    [animation setForward:YES];

    [animation startAnimation];
}

@end

@implementation _OLProjectViewAnimation : CPAnimation
{
    CPView  newView;
    CPView  oldView;
    
    BOOL    forward      @accessors;
}
 
- (id)initWithNewView:(CPView)aProjectView oldView:(CPView)aDashboardView
{
    self = [super initWithDuration:1.5 animationCurve:CPAnimationEaseInOut];
    
    if (self)
    {
        newView = aProjectView;
        oldView = aDashboardView;
        forward = false;
    }
    
    return self;
}
 
- (void)setCurrentProgress:(float)aProgress
{
    [super setCurrentProgress:aProgress];
    
    var value = [self currentValue];
    
    var width = [oldView frame].size.width;
    
    if(forward)
    {
        [newView setFrameOrigin:CGPointMake(0 - (width * (1 - value)), 0)];
        [oldView setFrameOrigin:CGPointMake((width * value), 0)];
    }
    else
    {
        [newView setFrameOrigin:CGPointMake(width * (1 - value), 0)];
        [oldView setFrameOrigin:CGPointMake(0 - (width * value), 0)];
    }
    
    if(value === 1.0)
    {
        [oldView setHidden:YES];
    }
}
 
@end
