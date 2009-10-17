@import "OLResource.j"
@import "OLLanguage.j"

@implementation OLApplication : CPObject
{
	CPArray _resources @accessors(property=resources, readonly);
	CPString _name @accessors(property=name, readonly);
	OLLanguage _language @accessors(property=language, readonly);
}

- (id)initWithName:(CPString)aName
{
	if(self = [super init])
	{
		_resources = [[CPArray alloc] init];
		_name = aName;
	}
	return self;
}

- (void)addResource:(OLResource)resourceToAdd
{
	[_resources addObject:resourceToAdd];
}

@end
