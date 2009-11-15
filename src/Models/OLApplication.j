@import "OLActiveRecord.j"
@import "OLResource.j"
@import "OLLanguage.j"
@import "OLResourceBundle.j"
@import "CPArray+Find.j"

@implementation OLApplication : OLActiveRecord
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

var OLApplicationNameKey = @"OLApplicationNameKey";
var OLApplicationResourceBundlesKey = @"OLApplicationResourceBundlesKey";

@implementation OLApplication (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aCoder decodeObjectForKey:OLApplicationNameKey];
        _resourceBundles = [aCoder decodeObjectForKey:OLApplicationResourceBundlesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_name forKey:OLApplicationNameKey];
    [aCoder encodeObject:_resourceBundles forKey:OLApplicationResourceBundlesKey];
}

@end
