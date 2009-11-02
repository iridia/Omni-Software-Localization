@import "OLActiveRecord.j"

/*!
 * The OLResourceBundle represents a bundle of resources of a specific language.
 */
@implementation OLResourceBundle : OLActiveRecord
{
	OLLanguage _language @accessors(property=language, readonly);
	OLResourceBundle _baseBundle @accessors(property=baseBundle);
	CPArray _resources @accessors(property=resources, readonly);
}

- (id)initWithLanguage:(OLLanguage)aLanguage
{
	[self initWithResources:[CPArray array] language:aLanguage];
}

- (id)initWithResources:(CPArray)someResources language:(OLLanguage)aLanguage
{
	if(self = [super init])
	{
		_language = aLanguage;
		_resources = someResources;
	}
	return self;
}

- (void)addResource:(OLResource)aResource
{
	[_resources addObject:aResource];
}

@end

var OLResourceBundleLanguageKey = @"OLResourceBundleLanguageKey";
var OLResourceBundleResourcesKey = @"OLResourceBundleResourcesKey";

@implementation OLResourceBundle (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _language = [aCoder decodeObjectForKey:OLResourceBundleLanguageKey];
        _resources = [aCoder decodeObjectForKey:OLResourceBundleResourcesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_language forKey:OLResourceBundleLanguageKey];
    [aCoder encodeObject:_resources forKey:OLResourceBundleResourcesKey];
}

@end
