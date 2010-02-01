@import "OLProjectController.j"

@implementation OLMyProjectController : OLProjectController
{
	OLImportProjectController   importProjectController;
}

- (id)init
{
    if(self = [super init])
    {
        projectView = [[OLProjectView alloc] initWithFrame:OSL_MAIN_VIEW_FRAME];
        [projectView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
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
