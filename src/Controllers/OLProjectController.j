@import <Foundation/CPObject.j>
@import <Foundation/CPUserSessionManager.j>

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
    }
    return self;
}

- (void)loadProjects
{
	[OLProject listWithCallback:function(project){[self addProject:project];}];
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
    	    [self setSelectedProject:item];
        }
	}
	else
	{
	    [self setSelectedProject:nil];
	}
}

@end
