@import <Foundation/CPObject.j>

@import "../Utilities/OLUserSessionManager.j"
@import "../Models/OLProject.j"
@import "../Views/OLResourcesView.j"

// Manages an array of projects
@implementation OLProjectController : CPObject
{
    CPArray         projects       	    @accessors;
	OLProject	    selectedProject		@accessors;
	OLResourcesView projectView         @accessors;
}

- (id)init
{
    if(self = [super init])
    {        
		projects = [CPArray array];

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
		    selector:@selector(didReceiveProjectShouldBranchNotification:)
		    name:@"OLProjectShouldBranchNotification"
		    object:nil];
		    
        [[CPNotificationCenter defaultCenter]
    	    addObserver:self
    		selector:@selector(didReceiveProjectsShouldReloadNotification:)
    		name:@"OLProjectsShouldReload"
    		object:nil];
    		
    }
    return self;
}

- (void)loadProjects
{
    if ([[CPUserSessionManager defaultManager] status] === CPUserSessionLoggedInStatus)
    {
        var userLoggedIn = [[CPUserSessionManager defaultManager] userIdentifier];
        var numOfAddedProjects = 0;
        [OLProject findByUserIdentifier:userLoggedIn callback:function(project)
    	{
            [self addProject:project];
            numOfAddedProjects++;
        }];
    }
	
}

- (void)insertObject:(OLProject)project inProjectsAtIndex:(int)index
{
    [projects insertObject:project atIndex:index];
}

- (void)addProject:(OLProject)project
{
    [self insertObject:project inProjectsAtIndex:[projects count]];
}

- (void)addResource:(JSObject)jsonResponse toResourceBundle:(OLResourceBundle)resourceBundle
{
	var fileName = jsonResponse.fileName;
	var fileType = jsonResponse.fileType;
	
	var resourceLineItems = [self lineItemsFromResponse:jsonResponse];

	var resource = [[OLResource alloc] initWithFileName:fileName fileType:fileType lineItems:resourceLineItems];
	
	[resourceBundle addResource:resource];
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
	else
	{
		[self addResource:jsonResponse toResourceBundle:nil];
	}
}

- (void)didReceiveProjectDidChangeNotification:(CPNotification)notification
{
    [selectedProject save];
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

- (void)alertDidEnd:(CPAlert)theAlert returnCode:(int)returnCode
{
    if(returnCode === 1 && [[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var clonedProject = [selectedProject clone];
        [clonedProject setUserIdentifier:[[OLUserSessionManager defaultSessionManager] userIdentifier]];
        [clonedProject save];
        [self addProject:clonedProject];
    }
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
	            object:[OLMenuItemNewLanguage, OLMenuItemDeleteLanguage]];
    	    [self setSelectedProject:item];
        }
	}
	else
	{
	    [self setSelectedProject:nil];
	}
}

@end
