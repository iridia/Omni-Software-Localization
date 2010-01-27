@import "OLActiveRecord.j"
@import "OLResourceBundle.j"
@import "OLUser.j"
@import "../Utilities/OLUserSessionManager.j"

@implementation OLProject : OLActiveRecord
{
    CPString    name                @accessors;
    CPArray     resourceBundles     @accessors(readonly);
    CPString    userIdentifier      @accessors;
    long        votes;
}

+ (id)projectFromJSON:(JSON)json
{
    var userIdentifier = @"";
    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        userIdentifier = [[OLUserSessionManager defaultSessionManager] userIdentifier];
    }
    else
    {
        [OLException raise:@"Project" reason:@"you must be logged in in order to create a project!"];
    }
    
	var project = [[self alloc] initWithName:json.fileName userIdentifier:userIdentifier];

    for (var i = 0; i < json.resourcebundles.length; i++)
    {        
        [project addResourceBundle:[OLResourceBundle resourceBundleFromJSON:json.resourcebundles[i]]];
    }
	
	return project;
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
        votes = 0;
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

- (CPString)sidebarName
{
    return [self name];
}

- (OLProject)clone
{
    result = [[OLProject alloc] initWithName:name userIdentifier:userIdentifier];
    
    for(var i = 0; i < [resourceBundles count]; i++)
    {
        [result addResourceBundle:[[resourceBundles objectAtIndex:i] clone]];
    }
    
    return result;
}

- (CPString)sidebarName
{
    return [self name];
}

- (void)setVotes:(long)someVotes
{
    votes = someVotes;
}

- (long)totalOfAllVotes
{
    return votes;
}

- (void)voteUp
{
    votes += 1;
}

- (void)voteDown
{
    votes-=1;
}
@end

var OLProjectNameKey = @"OLProjectNameKey";
var OLProjectResourceBundlesKey = @"OLProjectResourceBundlesKey";
var OLProjectUserKey = @"OLProjectUserKey";
var OLProjectVotesKey = @"OLProjectVotesKey";

@implementation OLProject (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        name = [aCoder decodeObjectForKey:OLProjectNameKey];
        resourceBundles = [aCoder decodeObjectForKey:OLProjectResourceBundlesKey];
        userIdentifier = [aCoder decodeObjectForKey:OLProjectUserKey];
        votes = [aCoder decodeObjectForKey:OLProjectVotesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:name forKey:OLProjectNameKey];
    [aCoder encodeObject:resourceBundles forKey:OLProjectResourceBundlesKey];
    [aCoder encodeObject:userIdentifier forKey:OLProjectUserKey];
    [aCoder encodeObject:votes forKey:OLProjectVotesKey];
}

@end
