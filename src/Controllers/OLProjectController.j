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
    }
    return self;
}

- (void)parseJSONResponse:(id)aResponse
{
	var project = [[OLProject alloc] initWithName:aResponse.fileName];

	for(var i = 0; i < aResponse.resourcebundles.length; i++)
	{
		var resourceBundle = [[OLResourceBundle alloc] initWithLanguage:[OLLanguage english]];
		[project addResourceBundle:resourceBundle];
	}

	[self addProject:project];
}

- (void)insertObject:(OLProject)project inProjectsAtIndex:(int)index
{
    [_projects insertObject:project atIndex:index];
}

- (void)addProject:(OLProject)project
{
    [self insertObject:project inProjectsAtIndex:[_projects count]];
}

@end
