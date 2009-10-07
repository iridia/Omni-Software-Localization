@import <Foundation/CPObject.j>

@import "EJTwitterController.j"
@import "EJGitHubController.j"
@import "EJRSSController.j"
@import "../Users/EJUserController.j"

/*
 * Initializes and tracks the individual source controllers.
 */
@implementation EJSourceController : CPObject
{
    CPArray _sources @accessors(property=sources);
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _sources = [];
    }
    
    return self;
}

- (void)readSourcesFromBundle
{    
    var bundle = [CPBundle mainBundle];
    var bundleSources = [bundle objectForInfoDictionaryKey:@"EJSources"];
    
    for (var i = 0; i < [bundleSources count]; i++)
    {
        var source = [bundleSources objectAtIndex:i];
        var key = [source objectForKey:@"key"];
        var classAsString = objj_getClass([source objectForKey:@"class"]);
        [self insertObject:[[classAsString alloc] initWithKey:key] inSourcesAtIndex:i];
    }
}

- (void)insertObject:(EJAbstractSourceController)source inSourcesAtIndex:(CPInteger)index
{
    [_sources insertObject:source atIndex:index];
}

- (void)fetchDataForUser:(EJUser)user
{
    if ([user displayName] === @"All Users")
    {
        console.log("ALL USERS");
    }
    for (var i = 0; i < [_sources count]; i++)
    {
        var source = [_sources objectAtIndex:i];
        [source setCurrentUser:user];
        [source fetchDataForCurrentUser];
    }
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"currentUser":
            var user = [change objectForKey:CPKeyValueChangeNewKey];
            if ([[user data] count] <= 0)
            {                
                [self fetchDataForUser:user];
            }
            else
            {
                console.log("we have already fetched data for", [user displayName]);
            }
            break;
        
        case @"currentSource":
            console.log("source has changed");
            break;
        
        default:
            console.warn("Unhandled keyPath");
            break;
    }
}

@end