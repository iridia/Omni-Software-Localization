@import "OLActiveRecord.j"

@implementation OLProject : OLActiveRecord
{
    CPString    _name               @accessors(property=name);
    CPArray     _resourceBundles    @accessors(property=resourceBundles, readonly);
}

- (id)init
{
    return [self initWithName:@"Untitled Project"];
}

- (id)initWithName:(CPString)name
{
    if (self = [super init])
    {
        _name = name;
		_resourceBundles = [CPArray array];
    }
    return self;
}

- (void)resources
{
	var defaultResourceBundle = [_resourceBundles objectAtIndex:0]; // FIXME: This should not be hard coded
	return [defaultResourceBundle resources];
}

- (void)addResourceBundle:(OLResourceBundle)aResourceBundle
{
	[_resourceBundles addObject:aResourceBundle];
}

@end

var OLProjectNameKey = @"OLProjectNameKey";
var OLProjectResourceBundlesKey = @"OLProjectResourceBundlesKey";

@implementation OLProject (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _name = [aCoder decodeObjectForKey:OLProjectNameKey];
        _resourceBundles = [aCoder decodeObjectForKey:OLProjectResourceBundlesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_name forKey:OLProjectNameKey];
    [aCoder encodeObject:_resourceBundles forKey:OLProjectResourceBundlesKey];
}

@end
