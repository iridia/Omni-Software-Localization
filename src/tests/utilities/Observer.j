@import <Foundation/CPObject.j>
 
@implementation Observer : CPObject
{
    CPArray postedNotifications;
}
 
- (id)init
{
    if (self = [super init])
    {
        postedNotifications   = [CPArray array];
    }
    return self;
}
 
- (void)startObserving:(CPString)aNotificationName
{
    [[CPNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationPosted:)
                                                 name:aNotificationName
                                               object:nil];
}

- (void)clearObservations:(CPString)aNotificationName
{
    [postedNotifications removeObject:aNotificationName];
}
 
- (void)notificationPosted:(id)sender
{
    [postedNotifications addObject:[sender name]];
}
 
- (BOOL)didObserve:(CPString)aNotificationName
{
    return [postedNotifications containsObject:aNotificationName];
}
 
@end