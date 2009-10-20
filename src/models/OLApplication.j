@import "OLResource.j"
@import "OLLanguage.j"
@import "OLResourceBundle.j"
@import "Find+CPArray.j"

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

- (CPArray)getResourceBundleOfLanguage:(OLLanguage)languageToFind
{
	return [_resourceBundles findBy:function(rsrc){return [[rsrc language] equals:languageToFind];}];
}

@end