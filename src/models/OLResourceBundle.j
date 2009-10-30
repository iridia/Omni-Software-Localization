/*!
 * The OLResourceBundle represents a bundle of resources of a specific language.
 */
@implementation OLResourceBundle : CPObject
{
	OLLanguage _language @accessors(property=language, readonly);
	OLResourceBundle _baseBundle @accessors(property=baseBundle);
	CPArray _resources @accessors(property=resources, readonly);
}

- (id)initWithResources:(CPArray)someResources ofLanguage:(OLLanguage)aLanguage
{
	if(self = [super init])
	{
		_language = aLanguage;
		_resources = someResources;
	}
	return self;
}

- (id)initWithLanguage:(OLLanguage)aLanguage
{
	if(self = [super init])
	{
		_language = aLanguage;
		_resources = [[CPArray alloc] init];
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
