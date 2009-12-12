@import <Foundation/CPObject.j>

@import "../Models/OLProject.j"

// Manages an array of projects
@implementation OLProjectController : CPObject
{
    CPArray     _projects       @accessors(property=projects);
    id          _delegate       @accessors(property=delegate);
}

- (id)init
{
    if(self = [super init])
    {
        var iTunes = [[OLProject alloc] initWithName:@"iTunes"];
        var safari = [[OLProject alloc] initWithName:@"Safari"];
        var things = [[OLProject alloc] initWithName:@"Things"];
        
        _projects = [iTunes, safari, things];

		[[CPNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(didReceiveParseServerResponseNotification:)
			name:@"OLUploadControllerDidParseServerResponse"
			object:nil];
    }
    return self;
}

- (void)insertObject:(OLProject)project inProjectsAtIndex:(int)index
{
    [_projects insertObject:project atIndex:index];
}

- (void)addProject:(OLProject)project
{
    [self insertObject:project inProjectsAtIndex:[_projects count]];
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

- (void)createNewProject:(JSObject)jsonResponse
{	
	var project = [[OLProject alloc] initWithName:jsonResponse.fileName];

	for(var i = 0; i < jsonResponse.resourcebundles.length; i++)
	{
		var resources = [CPArray array];
		
		for(var j = 0; j < jsonResponse.resourcebundles[i].resources.length; j++)
		{
			var theResource = jsonResponse.resourcebundles[i].resources[j];
			var lineItems = [CPArray array];
			for(var k = 0; k < theResource.dict.key.length; k++)
			{
				[lineItems addObject:[[OLLineItem alloc] initWithIdentifier:theResource.dict.key[k] value:theResource.dict.string[k]]];
			}
			
			[resources addObject:[[OLResource alloc] initWithFileName:theResource.fileName fileType:theResource.fileType lineItems:lineItems]];
		}
		
		var resourceBundle = [[OLResourceBundle alloc] initWithResources:resources language:[OLLanguage english]];
		[project addResourceBundle:resourceBundle];
	}

	[self addProject:project];
	[project save];
}

- (void)addResource:(JSObject)jsonResponse toResourceBundle:(OLResourceBundle)resourceBundle
{
	var resourceLineItems = [[CPArray alloc] init];

	var fileName = jsonResponse.fileName;
	var fileType = jsonResponse.fileType;
	var lineItemKeys = jsonResponse.dict.key;
	var lineItemStrings = jsonResponse.dict.string;	

	for (var i = 0; i < [lineItemKeys count]; i++)
	{
		[resourceLineItems addObject:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i]]];
	}

	var resource = [[OLResource alloc] initWithFileName:fileName fileType:fileType lineItems:resourceLineItems];
	
	[resourceBundle addResource:resource];
}

@end
