@import "OLProjectController.j"
@import "OLUploadController.j"
@import "../Views/OLProjectView.j"
@import "../Views/OLLineItemEditWindow.j"
@import "../Utilities/OLConstants.j"

@implementation OLMyProjectController : OLProjectController
{
	OLImportProjectController   importProjectController;
	
	OLProjectView               projectView;
	OLLineItemEditWindow        editLineItemWindow;
}

- (id)init
{
    if(self = [super init])
    {
        projectView = [[OLProjectView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        [projectView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
     
        importProjectController = [[OLImportProjectController alloc] init];
   		
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
        
	    editLineItemWindow = [[OLLineItemEditWindow alloc] initWithContentRect:CGRectMake(0, 0, 400, 400) styleMask:CPBorderlessBridgeWindowMask];
	    [editLineItemWindow setDelegate:self];
    }
    return self;
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    
	[[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveParseServerResponseNotification:)
		name:OLUploadControllerDidParseServerResponse
		object:nil];

	[[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
		name:CPOutlineViewSelectionDidChangeNotification
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
       selector:@selector(startCreateNewBundle:)
       name:OLProjectShouldCreateBundleNotification
       object:nil];

   [[CPNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(startDeleteBundle:)
       name:OLProjectShouldDeleteBundleNotification
       object:nil];

   [[CPNotificationCenter defaultCenter]
       addObserver:self
       selector:@selector(downloadSelectedProject:)
       name:OLProjectShouldDownloadNotification
       object:nil];

    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(createBroadcastMessage:)
        name:OLProjectShouldBroadcastMessage
        object:nil];

    [[CPNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(startImport:)
        name:OLProjectShouldImportNotification
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
        postNotificationName:OLMessageControllerShouldCreateMessageNotification
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

- (void)editSelectedLineItem
{
    [editLineItemWindow makeKeyAndOrderFront:self];
    [self reloadDataOnEditLineItemWindow];
}

- (void)nextLineItem
{
    if(![[[editLineItemWindow valueTextField] stringValue] isEqualToString:[resourceBundleController valueForSelectedLineItem]])
    {
        [self saveLineItem];
    }
        
    [resourceBundleController nextLineItem];
    [self reloadDataOnEditLineItemWindow];
}

- (void)previousLineItem
{
    if(![[[editLineItemWindow valueTextField] stringValue] isEqualToString:[resourceBundleController valueForSelectedLineItem]])
    {
        [self saveLineItem];
    }
        
    [resourceBundleController previousLineItem];
    [self reloadDataOnEditLineItemWindow];
}

- (void)saveLineItem
{

    var value = [[editLineItemWindow valueTextField] stringValue];
    if (value !== [resourceBundleController valueForSelectedLineItem])
    {
        [self setValueForSelectedLineItem:value];
    }
}

-(void)setValueForSelectedLineItem:(CPString)stringValue
{
    [OLUndoManager registerUndoWithTarget:self selector:@selector(setValueForSelectedLineItem:) object:[resourceBundleController valueForSelectedLineItem]];
    [resourceBundleController setValueForSelectedLineItem:stringValue];
    [selectedProject saveWithCallback:function(){[projectView reloadData];}];
}

- (void)saveComment
{
    var value = [[editLineItemWindow commentTextField] stringValue];
    [resourceBundleController addCommentForSelectedLineItem:value];
    // [selectedProject saveWithCallback:function(){[self loadProjects];}];
    [self reloadDataOnEditLineItemWindow];
}

- (void)reloadDataOnEditLineItemWindow
{
    [editLineItemWindow setTitle:[resourceBundleController titleOfSelectedResource]];
    [editLineItemWindow setComment:[resourceBundleController commentForSelectedLineItem]];
    [editLineItemWindow setEnglishValue:[resourceBundleController englishValueForSelectedLineItem]];
    [editLineItemWindow setValue:[resourceBundleController valueForSelectedLineItem]];
    [editLineItemWindow setComments:[resourceBundleController commentsForSelectedLineItem]];
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

- (void)startCreateNewBundle:(id)sender
{
    if(![[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to add a new language!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(startCreateNewBundle:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
        
        [[CPNotificationCenter defaultCenter]
            postNotificationName:OLLoginControllerShouldLoginNotification
            object:nil
            userInfo:userInfo];
        
        return;
    }
    else if(![[OLUserSessionManager defaultSessionManager] isUserTheLoggedInUser:[selectedProject userIdentifier]])
    {
        [self branchSelectedProject];        
        return;
    }
    
    [resourceBundleController startCreateNewBundle:sender];
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
}

- (CPString)projectName
{
    return [selectedProject name];
}

- (CPArray)comments
{
    return [selectedProject comments];
}

@end

@implementation OLMyProjectController (SidebarItem)

- (BOOL)shouldExpandSidebarItemOnReload
{
    return YES;
}

- (CPString)sidebarName
{
    return @"Projects";
}

- (CPArray)sidebarItems
{
    return projects;
}

- (void)didReceiveOutlineViewSelectionDidChangeNotification:(CPNotification)notification
{
	var outlineView = [notification object];

	var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
	var item = [outlineView itemAtRow:selectedRow];

	var parent = [outlineView parentForItem:item];
	
	if (parent === self)
	{
	    if (selectedProject !== item)
	    {
	        [[CPNotificationCenter defaultCenter]
	            postNotificationName:OLMenuShouldEnableItemsNotification
	            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage, OLMenuItemDownload, OLMenuItemImport, OLMenuItemBroadcast]];

    	    [self setSelectedProject:item];
            [projectView selectResourcesTableViewRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
            [projectView setTitle:[[self selectedProject] name]];
            [projectView reloadData];
            
            // tell content view controller to update view
    		[[CPNotificationCenter defaultCenter]
    		  postNotificationName:OLContentViewControllerShouldUpdateContentView
    		  object:self
    		  userInfo:[CPDictionary dictionaryWithObject:projectView forKey:@"view"]];
        }
	}
	else
	{
	    [[CPNotificationCenter defaultCenter]
            postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage, OLMenuItemDownload, OLMenuItemImport, OLMenuItemBroadcast]];

	    [self setSelectedProject:nil];
	}
}

@end
