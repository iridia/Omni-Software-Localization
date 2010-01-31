@import "OLProjectController.j"

@implementation OLProjectSearchController : OLProjectController
{
    OLProjectSearchView     searchView      @accessors;
    CPView                  contentView     @accessors(readonly);
    CPString                ownerName;
    
    OLContentViewController contentViewController   @accessors;
}

- (void)init
{
    self = [super init];
    if(self)
    {
        searchView = [[OLProjectSearchView alloc] initWithFrame:OSL_MAIN_VIEW_FRAME];
        [searchView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        projectView = [[OLProjectResultView alloc] initWithFrame:OSL_MAIN_VIEW_FRAME];
   		
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
        
        [searchView setDataSource:self];
        [searchView setDelegate:self];
        contentView = searchView;
   		
   		[self registerForNotifications];
    }
    return self;
}

- (void)registerForNotifications
{
    [[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveProjectControllerFinished:)
		name:@"OLProjectControllerDidFinishSavingNotification"
		object:nil];
		
	[[CPNotificationCenter defaultCenter]
	    addObserver:self
	    selector:@selector(didReceiveProjectDidChangeNotification:)
	    name:@"OLProjectDidChangeNotification"
	    object:nil];
        
	[[CPNotificationCenter defaultCenter]
	   addObserver:self
	   selector:@selector(didReceiveLineItemSelectedIndexDidChangeNotification:)
	   name:OLLineItemSelectedLineItemIndexDidChangeNotification
	   object:[[resourceBundleController resourceController] lineItemController]];
}

- (void)loadProjects
{
    projects = [CPArray array];
    [OLProject findAllProjectsByNameWithCallback:function(project, isFinal)
    {
        [self addProject:project];

        if(isFinal)
        {
            [self sortProjects];
            [self reloadData];
        }
    }];
}

- (void)sortProjects
{
   projects = [projects sortedArrayUsingFunction:function(lhs, rhs, context){  
           return [[rhs totalOfAllVotes] compare:[lhs totalOfAllVotes]];
       }];
}

- (void)reloadData
{
    [searchView reloadData];
}

- (void)setContentView:(CPView)aView
{
    if(aView === contentView)
        return;
    
    contentView = aView;
    
    [contentViewController setCurrentView:contentView];
}

- (void)didReceiveProjectControllerFinished:(CPNotification)notification
{
    [self loadProjects];
}

@end

@implementation OLProjectSearchController (OwnerDataSource)

- (CPString)owner
{
    if([selectedProject userIdentifier] === [[OLUserSessionManager defaultSessionManager] userIdentifier])
    {
        return "yours";
    }
    
    return ownerName;
}

@end

@implementation OLProjectSearchController (OLProjectSearchDataSource)

- (int)numberOfRowsInTableView:(CPTableView)tableView
{
    if(tableView === [searchView allProjectsTableView])
    {
        return [projects count];
    }
    
    return [super numberOfRowsInTableView:tableView];
}
 
- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var projectTableView = [searchView allProjectsTableView];
    if(tableView === projectTableView)
    {
        if([tableColumn identifier] === @"ProjectName")
        {
            return [[projects objectAtIndex:row] name];
        }
        else if ([tableColumn identifier] === @"TotalVotes")
        {
            return [[projects objectAtIndex:row] totalOfAllVotes];
        }

    }
    
    return [super tableView:tableView objectValueForTableColumn:tableColumn row:row];
}

- (void)tableViewDidDoubleClickItem:(CPTableView)aTableView
{
    if(aTableView === [searchView allProjectsTableView])
    {
        var index = [[aTableView selectedRowIndexes] firstIndex];
        var theProject = [projects objectAtIndex:index];
        
        [theProject getWithCallback:function(project)
        {
            [OLUser findByRecordID:[project userIdentifier] withCallback:function(user)
            {
                ownerName = [user email];
            
                [self setSelectedProject:project];
    
                [projectView setBackButtonDelegate:self];
                [self setContentView:projectView];
        
                [projectView reloadAllData];
            }];
        }];
        return;
    }
    
    [super performSelector:[super doubleAction] withObject:aTableView];
}

- (SEL)doubleAction
{
    return CPSelectorFromString("tableViewDidDoubleClickItem:")
}

- (void)back:(id)sender
{
    [self setContentView:searchView];
}

@end

@implementation OLProjectSearchController (Branching)

- (void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode
{
    if(returnCode === 1 && [[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        [selectedProject addSubscriber:[[OLUserSessionManager defaultSessionManager] userIdentifier]];
        [selectedProject save];
        
        var clonedProject = [selectedProject clone];
        [clonedProject setUserIdentifier:[[OLUserSessionManager defaultSessionManager] userIdentifier]];
        [clonedProject saveWithCallback:function(project){
            [[CPNotificationCenter defaultCenter]
                postNotificationName:OLProjectShouldReloadMyProjectsNotification
                object:self];
        }];
    }
}

- (void)branchSelectedProject
{    
    var alert = [[CPAlert alloc] init];
    [alert setTitle:@"Not your project!"];
    [alert setMessageText:@"This is not your project. In order to start localizing, you will need to create your own. Do you want to create your own project of this application?"];
    [alert setAlertStyle:CPInformationalAlertStyle];
    [alert addButtonWithTitle:@"No"];
    [alert addButtonWithTitle:@"Yes"];
    [alert setDelegate:self];
    [alert runModal];
}

@end