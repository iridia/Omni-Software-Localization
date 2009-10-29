@import "OLActiveRecord.j"
@import "OLResource.j"
@import "OLLanguage.j"
@import "OLResourceBundle.j"
@import "Find+CPArray.j"

@implementation OLApplication : OLActiveRecord
{
	CPString _name @accessors(property=name, readonly);
	CPArray _resourceBundles @accessors(property=resourceBundles, readonly);
}

- (id)initWithOId:(CPString)anOId
{
	[self initWithOId:anOId name:nil];
}

- (id)initWithOId:(CPString)anOId name:(CPString)aName
{
	if(self = [super initWithOId:anOId])
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

- (id)encode:(CPKeyedArchiver)archiver
{
	[super encode:archiver];
	[archiver encodeString:_name forKey:@"name"];
	[archiver encodeArray:_resourceBundles forKey:@"resourceBundles"];
}

- (void)decode:(CPKeyedUnarchiver)unarchiver
{
	[super decode:unarchiver];
	_name = [unarchiver decodeStringForKey:@"name"];
	_resourceBundles = [unarchiver decodeArrayForKey:@"resourceBundles"];
}

@end
