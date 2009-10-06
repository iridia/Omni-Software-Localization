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
    EJUserController _controller;
}

- (id)initWithUserController:(EJUserController)controller
{
    self = [super init];
    
    if (self)
    {
        _sources = [];
        _controller = controller;
        
        var bundle = [CPBundle mainBundle];
        var bundleSources = [bundle objectForInfoDictionaryKey:@"EJSources"];
        var users = [_controller users];
        
        for (var i = 0; i < [bundleSources count]; i++)
        {
            var source = [bundleSources objectAtIndex:i];
            var key = [source objectForKey:@"key"];
            var classAsString = objj_getClass([source objectForKey:@"class"]);
            [_sources addObject:[[classAsString alloc] initWithUsers:users andKey:key]];
        }
    }
    
    return self;
}