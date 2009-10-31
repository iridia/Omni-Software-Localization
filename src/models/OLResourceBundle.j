@import "OLResource.j"

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

- (id)encode:(CPKeyedArchiver)archiver
{
	[archiver encode:_language forKey:@"language"];
	[archiver encode:_baseBundle forKey:@"baseBundle"];
	[archiver encodeArray:_resources forKey:@"resources"];
}

- (void)decode:(CPKeyedUnarchiver)unarchiver
{
	_language = [unarchiver decodeObjectForKey:@"language"];
	_resources = [unarchiver decodeArrayForKey:@"resources"];
}

@end
