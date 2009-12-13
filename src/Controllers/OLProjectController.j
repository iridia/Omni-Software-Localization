@import <Foundation/CPObject.j>

@import "OLResourceController.j"
@import "../Models/OLProject.j"

// Manages an array of projects
@implementation OLProjectController : CPObject
{
    CPArray                     projects       	            @accessors;
	OLProject	                selectedProject		        @accessors;
	
    // OLResourceBundleController   resourceBundleController    @accessors(readonly);
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
		    selector:@selector(didReceiveLineItemValueDidChangeNotification:)
		    name:@"OLLineItemValueDidChangeNotification"
		    object:nil];
    }
    return self;
}

- (void)loadProjects
{
	var projectList = [OLProject list];
	for (var i = 0; i < [projectList count]; i++)
	{
		[self addProject:[projectList objectAtIndex:i]];
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

- (void)createNewProject:(JSObject)jsonResponse
{	
	var project = [[OLProject alloc] initWithName:jsonResponse.fileName];

	var resources = [CPArray array];

	for(var i = 0; i < jsonResponse.resourcebundles.length; i++)
	{		
		for(var j = 0; j < jsonResponse.resourcebundles[i].resources.length; j++)
		{
			var theResource = jsonResponse.resourcebundles[i].resources[j];
			var lineItems = [self lineItemsFromResponse:theResource];
			
			[resources addObject:[[OLResource alloc] initWithFileName:theResource.fileName fileType:theResource.fileType lineItems:lineItems]];
		}
	}
	
	var resourceBundle = [[OLResourceBundle alloc] initWithResources:resources language:[OLLanguage english]];
	[project addResourceBundle:resourceBundle];

	[self addProject:project];
	[project save];
}

- (void)addResource:(JSObject)jsonResponse toResourceBundle:(OLResourceBundle)resourceBundle
{
	var fileName = jsonResponse.fileName;
	var fileType = jsonResponse.fileType;
	
	var resourceLineItems = [self lineItemsFromResponse:jsonResponse];

	var resource = [[OLResource alloc] initWithFileName:fileName fileType:fileType lineItems:resourceLineItems];
	
	[resourceBundle addResource:resource];
}

- (void)didReceiveOutlineViewSelectionDidChangeNotification:(CPNotification)notification
{
	var outlineView = [notification object];

	var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
	var item = [outlineView itemAtRow:selectedRow];

	var parent = [outlineView parentForItem:item];

	if (parent === @"Projects")
	{
	    if (selectedProject !== item)
	    {
    	    [self setSelectedProject:item];
        }
	}
}

- (void)didReceiveParseServerResponseNotification:(CPNotification)notification
{
	var jsonResponse = [[notification object] jsonResponse];

	if (jsonResponse.fileType === @"zip")
	{
		[self createNewProject:jsonResponse]
	}
	else
	{
		[self addResource:jsonResponse toResourceBundle:nil];
	}
}

- (void)didReceiveLineItemValueDidChangeNotification:(CPNotification)notification
{
    [selectedProject save];
}

- (void)lineItemsFromResponse:(JSObject)jsonResponse
{
	var result = [CPArray array];
	var lineItemKeys = jsonResponse.dict.key;
	var lineItemStrings = jsonResponse.dict.string;
	
	if(jsonResponse.fileType == "strings")
	{
		var lineItemComments = jsonResponse.comments_dict.string;

		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[result addObject:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i] comment:lineItemComments[i]]];
		}	
	}
	else
	{
		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[result addObject:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i]]];
		}
	}
	return result;
}

@end
