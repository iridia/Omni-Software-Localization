@import "OLActiveRecord.j"
@import "OLResourceBundle.j"
@import "OLUser.j"

@implementation OLProject : OLActiveRecord
{
    CPString    name                @accessors;
    CPArray     resourceBundles     @accessors(readonly);
    CPString    userIdentifier      @accessors;
}

- (id)init
{
    return [self initWithName:@"Untitled Project"];
}

- (id)initWithName:(CPString)aName
{
    return [self initWithName:aName userIdentifier:@""];
}

- (id)initWithName:(CPString)aName userIdentifier:(CPString)aUserIdentifier
{
    if (self = [super init])
    {
        name = aName;
        resourceBundles = [CPArray array];
        userIdentifier = aUserIdentifier;
    }
    return self;
}

- (void)resources
{
	var defaultResourceBundle = [resourceBundles objectAtIndex:0]; // FIXME: This should not be hard coded
	return [defaultResourceBundle resources];
}

- (void)addResourceBundle:(OLResourceBundle)aResourceBundle
{
	[resourceBundles addObject:aResourceBundle];
}

@end

var OLProjectNameKey = @"OLProjectNameKey";
var OLProjectResourceBundlesKey = @"OLProjectResourceBundlesKey";
var OLProjectUserKey = @"OLProjectUserKey";

@implementation OLProject (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        name = [aCoder decodeObjectForKey:OLProjectNameKey];
        resourceBundles = [aCoder decodeObjectForKey:OLProjectResourceBundlesKey];
        userIdentifier = [aCoder decodeObjectForKey:OLProjectUserKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:name forKey:OLProjectNameKey];
    [aCoder encodeObject:resourceBundles forKey:OLProjectResourceBundlesKey];
    [aCoder encodeObject:userIdentifier forKey:OLProjectUserKey];
}

@end
