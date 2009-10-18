@import "OLResource.j"
@import "OLLanguage.j"

@implementation OLApplication : CPObject
{
	CPString _name @accessors(property=name, readonly);
	CPArray _resourceBundles @accessors(property=resourceBundles, readonly);
}

- (id)initWithName:(CPString)aName
{
	if(self = [super init])
	{
		_resourceBundles = [[CPArray alloc] init];
		_name = aName;
	}
	
	return self;
}

- (void)addResourceBundle:(OLResourceBundle)aResourceBundle
{
	[_resourceBundles addObject:aResourceBundle];
}

- (CPArray)getResourceBundleOfLanguage:(OLLanguage)language
{
	for(int i = 0; i < [_resourceBundles count]; i++)
	{
		if([[[_resourceBundles objectAtIndex:i] language] equals:language]		)
		{
			return [_resourceBundles objectAtIndex:i];
		}
	}
	
	return nil;
}

@end
