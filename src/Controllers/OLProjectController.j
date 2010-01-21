@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Models/OLProject.j"
@import "../Views/OLProjectView.j"

@import "OLResourceBundleController.j"

// Manages an array of projects
@implementation OLProjectController : CPObject
{
    CPArray         projects       	    @accessors;
	OLProject	    selectedProject		@accessors;
	OLProjectView   projectView;
	
	OLResourceBundleController  resourceBundleController;
}

- (id)init
{
    if(self = [super init])
    {        
		projects = [CPArray array];
		
		resourceBundleController = [[OLResourceBundleController alloc] init];
        [self addObserver:resourceBundleController forKeyPath:@"selectedProject" options:CPKeyValueObservingOptionNew context:nil];
   		
   		[self registerForNotifications];
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
		selector:@selector(didReceiveProjectsShouldReloadNotification:)
		name:@"OLProjectsShouldReload"
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
}

- (void)loadProjects
{
    projects = [CPArray array];
    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userLoggedIn = [[OLUserSessionManager defaultSessionManager] userIdentifier];
        [OLProject findByUserIdentifier:userLoggedIn callback:function(project)
    	{
            [self addProject:project];
        }];
    }
	
}

- (void)downloadSelectedProject:(CPNotification)notification
{
    var request = [CPURLRequest requestWithURL:@"/~hammerdr/osl/src/Download/Download.php"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[selectedProject recordID]];
    [OLURLConnectionFactory createConnectionWithRequest:request delegate:nil];
}

- (void)insertObject:(OLProject)project inProjectsAtIndex:(int)index
{
    [projects insertObject:project atIndex:index];
}

- (void)addProject:(OLProject)project
{
    [self insertObject:project inProjectsAtIndex:[projects count]];
}

- (void)didReceiveParseServerResponseNotification:(CPNotification)notification
{
	var jsonResponse = [[notification object] jsonResponse];

	if (jsonResponse.fileType === @"zip")
	{
		var newProject = [OLProject projectFromJSON:jsonResponse];
		[self addProject:newProject];
    	[newProject save];
	}
}

- (void)didReceiveProjectDidChangeNotification:(CPNotification)notification
{
    [selectedProject save];
    [projectView reloadAllData];
}

- (void)didReceiveProjectShouldBranchNotification:(CPNotification)notification
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

- (void)didReceiveProjectsShouldReloadNotification:(CPNotification)notification
{
    [self loadProjects];
}

- (void)didReceiveLineItemSelectedIndexDidChangeNotification:(CPNotification)notification
{
    var index = [[notification userInfo] objectForKey:@"SelectedIndex"];
    
    [projectView selectLineItemsTableViewRowIndexes:[CPIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
}

- (void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode
{
    if(returnCode === 1 && [[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var clonedProject = [selectedProject clone];
        [clonedProject setUserIdentifier:[[OLUserSessionManager defaultSessionManager] userIdentifier]];
        [clonedProject saveWithCallback:function(project){
            [[CPNotificationCenter defaultCenter]
                postNotificationName:@"OLProjectsShouldReload"
                object:self];
        }];
    }
}

- (void)setProjectView:(OLProjectView)aProjectView
{
    if (projectView === aProjectView)
        return;
        
    projectView = aProjectView;
    
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

@end

@implementation OLProjectController (ProjectViewDataSource)

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
    
    return 0;
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

- (CPArray)titlesOfResourceBundlesForProjectView:(OLProjectView)projectView
{
    return [resourceBundleController titlesOfResourceBundles];
}

- (int)indexOfSelectedResourceBundleForProjectView:(OLProjectView)projectView
{
    return [resourceBundleController indexOfSelectedResourceBundle];
}

- (void)selectedResourceBundleDidChange:(int)selectedIndex
{
    [projectView selectResourcesTableViewRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
    [resourceBundleController selectResourceBundleAtIndex:selectedIndex];
    [projectView reloadAllData];
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
            postNotificationName:@"OLUserShouldLoginNotification"
            object:nil
            userInfo:userInfo];
        
        return;
    }
    else if(![[OLUserSessionManager defaultSessionManager] isUserTheLoggedInUser:[selectedProject userIdentifier]])
    {
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLProjectShouldBranchNotification"
            object:nil];
        
        return;
    }
    
    [resourceBundleController startCreateNewBundle:sender];
}

- (void)startDeleteBundle:(id)sender
{
    if(![[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to add a new language!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(startDeleteBundle:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];

        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLUserShouldLoginNotification"
            object:nil
            userInfo:userInfo];

        return;
    }
    else if(![[OLUserSessionManager defaultSessionManager] isUserTheLoggedInUser:[selectedProject userIdentifier]])
    {
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLProjectShouldBranchNotification"
            object:nil];

        return;
    }
    
    [resourceBundleController startDeleteBundle:sender];
}

@end

@implementation OLProjectController (ProjectViewDelegate)

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var tableView = [aNotification object];
    
    var selectedRow = [[tableView selectedRowIndexes] firstIndex];
    
    if (tableView === [projectView resourcesTableView])
    {
        [resourceBundleController selectResourceAtIndex:selectedRow];
        [projectView reloadLineItemsTableView];
        [projectView reloadVoting];
        [projectView selectLineItemsTableViewRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
        [projectView setIsEditing:(selectedRow !== CPNotFound)];
    }
    
    if (tableView === [projectView lineItemsTableView])
    {
        [resourceBundleController selectLineItemAtIndex:selectedRow];
    }
}

- (void)lineItemsTableViewDoubleClick:(CPTableView)tableView
{
    var userSessionManager = [OLUserSessionManager defaultSessionManager];
    if(![userSessionManager isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to edit this item!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(lineItemsTableViewDoubleClick:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
        
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLUserShouldLoginNotification"
            object:nil
            userInfo:userInfo];
        return;
    }
    else if(![userSessionManager isUserTheLoggedInUser:[selectedProject userIdentifier]])
    {
        [self didReceiveProjectShouldBranchNotification:nil];
            
        return;
    }
    
    [resourceBundleController editSelectedLineItem];
}

// HACK FOR CPTableView BUG (_doubleAction is a global var)
- (SEL)doubleAction
{
    return CPSelectorFromString(@"lineItemsTableViewDoubleClick:");
}

@end

@implementation OLProjectController (VotingDelegateAndDataSource)

- (void)voteUp:(id)sender
{
    [resourceBundleController voteUp];
    [projectView reloadVoting];
}

- (void)voteDown:(id)sender
{
    [resourceBundleController voteDown];
    [projectView reloadVoting];
}

- (int)numberOfVotesForSelectedResource
{
    return [resourceBundleController numberOfVotesForSelectedResource];
}

@end

@implementation OLProjectController (OwnerDataSource)

- (CPString)owner
{
    if([selectedProject userIdentifier] === [[OLUserSessionManager defaultSessionManager] userIdentifier])
    {
        return "yours";
    }
    
    return "not yours";
}

@end

@implementation OLProjectController (TitleDataSource)

- (CPString)title
{
    return [selectedProject name];
}

@end

@implementation OLProjectController (SidebarItem)

- (BOOL)shouldExpandSidebarItemOnReload
{
    return YES;
}

- (CPView)contentView
{
    return projectView;
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
	        [[CPNotificationCenter defaultCenter] postNotificationName:@"OLMenuShouldEnableItemsNotification" 
	            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage, OLMenuItemDownload]];
    	    [self setSelectedProject:item];
    	    [projectView selectResourcesTableViewRowIndexes:[CPIndexSet indexSet] byExtendingSelection:NO];
            [projectView setTitle:[[self selectedProject] name]];
            [projectView reloadAllData];
        }
	}
	else
	{
	    [self setSelectedProject:nil];
	}
}

@end
