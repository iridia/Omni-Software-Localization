@import "OLResource.j"
@import "OLLanguage.j"

@implementation OLApplication : CPObject
{
	CPString _name @accessors(property=name, readonly);
	CPDictionary _resourceLists @accessors(property=resourceLists, readonly);
}

- (id)initWithName:(CPString)aName
{
	if(self = [super init])
	{
		_resourceLists = [CPDictionary dictionary];
		_resources = [[CPArray alloc] init];
		_name = aName;
	}
	
	return self;
}

- (void)addResources:(OLArray)resourceToAdd ofLangugage:(OLLanguage)language
{
	[_resources addObject:resourceToAdd];
}

- (CPArray)getResourcesOfLanguage:(OLLanguage)language
{
	return [_resources objectForKey:language];
}

@end
