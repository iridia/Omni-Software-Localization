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
    CPArray _sources @accessors(property=sources, readonly);
    CPArray _currentUserData @accessors(property=currentUserData);
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _sources = [];
        _currentUserData = [];
        
        var bundle = [CPBundle mainBundle];
        var bundleSources = [bundle objectForInfoDictionaryKey:@"EJSources"];
        
        for (var i = 0; i < [bundleSources count]; i++)
        {
            var source = [bundleSources objectAtIndex:i];
            var key = [source objectForKey:@"key"];
            var classAsString = objj_getClass([source objectForKey:@"class"]);
            [_sources addObject:[[classAsString alloc] initWithKey:key]];
        }
    }
    
    return self;
}

- (void)insertObject:(id)anObject inCurrentUserDataAtIndex:(CPInteger)anIndex
{
    [_currentUserData insertObject:anObject atIndex:anIndex];
}

- (void)fetchDataForUser:(EJUser)user
{
    [_currentUserData removeAllObjects];
    for (var i = 0; i < [_sources count]; i++)
    {
        var source = [_sources objectAtIndex:i];
        [source setCurrentUser:user];
        [source addObserver:self forKeyPath:@"currentUserData" options:CPKeyValueObservingOptionNew context:nil];
        [source fetchDataForCurrentUser];
    }
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"currentUser":
            var user = [change objectForKey:CPKeyValueChangeNewKey];
            [self fetchDataForUser:user];
            break;
        
        case @"currentUserData":
            var data = [[change objectForKey:CPKeyValueChangeNewKey] objectAtIndex:0];
            [self insertObject:data inCurrentUserDataAtIndex:[_currentUserData count]];
            break;
        
        default:
            console.error("Unhandled keyPath");
            break;
    }
}

@end