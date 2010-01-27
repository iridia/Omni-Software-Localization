@import "OLProjectController.j"

@implementation OLProjectSearchController : OLProjectController
{
    OLProjectSearchView     searchView      @accessors;
    CPView                  contentView     @accessors(readonly);
    CPString                ownerName;
    
    OLContentViewController contentViewController   @accessors;
}

- (void)registerForNotifications
{
	[[CPNotificationCenter defaultCenter]
	    addObserver:self
	    selector:@selector(didReceiveProjectDidChangeNotification:)
	    name:@"OLProjectDidChangeNotification"
	    object:nil];

    [[CPNotificationCenter defaultCenter]
	    addObserver:self
		selector:@selector(didReceiveProjectsShouldReloadNotification:)
		name:@"OLProjectsShouldReload"
		object:nil];
        
	[[CPNotificationCenter defaultCenter]
	   addObserver:self
	   selector:@selector(didReceiveLineItemSelectedIndexDidChangeNotification:)
	   name:OLLineItemSelectedLineItemIndexDidChangeNotification
	   object:[[resourceBundleController resourceController] lineItemController]];
}

- (id)loadProjects
{
    projects = [CPArray array];
    [OLProject findAllProjectsByNameWithCallback:function(project){[self addProject:project];}];
}

- (void)setSearchView:(CPView)aSearchView
{
    if(searchView === aSearchView)
        return;
    
    searchView = aSearchView;
    [searchView setDataSource:self];
    [searchView setDelegate:self];
    contentView = searchView;
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
    if(tableView === [searchView allProjectsTableView])
    {
        return [[projects objectAtIndex:row] name];
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
        console.log(selectedProject);
        
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