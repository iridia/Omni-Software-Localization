@import <Foundation/CPObject.j>

OLUserSessionUndeterminedStatus = 0;
OLUserSessionLoggedInStatus     = 1;
OLUserSessionLoggedOutStatus    = 2;

OLUserSessionManagerStatusDidChangeNotification = @"OLUserSessionManagerStatusDidChangeNotification";
OLUserSessionManagerUserDidChangeNotification   = @"OLUserSessionManagerUserDidChangeNotification";

var OLDefaultUserSessionManager = nil;

@implementation OLUserSessionManager : CPObject
{
    OLUserSessionStatus status  @accessors(readonly);
    id                  user    @accessors(readonly);
}

+ (id)defaultSessionManager
{
    if (!OLDefaultUserSessionManager)
    {
        OLDefaultUserSessionManager = [[OLUserSessionManager alloc] init];
    }
    
    return OLDefaultUserSessionManager;
}

- (id)init
{
    if (self = [super init])
    {
        status = OLUserSessionUndeterminedStatus;
    }
    return self;
}

- (void)setStatus:(OLUserSessionStatus)aStatus
{
    if (status === aStatus)
        return;
    
    status = aStatus;
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLUserSessionManagerStatusDidChangeNotification
        object:self];
    
    if (status !== OLUserSessionLoggedInStatus)
    {
        [self setUser:nil];
    }    
}

- (void)setUser:(id)aUser
{
    if (user === aUser)
        return;
    
    user = aUser;
    
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLUserSessionManagerUserDidChangeNotification
        object:self];
        
    if (user)
    {
        [self setStatus:OLUserSessionLoggedInStatus];
    }
    else
    {
        [self setStatus:OLUserSessionLoggedOutStatus];
    }
}

- (BOOL)isUserLoggedIn
{
    return ([self status] === OLUserSessionLoggedInStatus);
}

- (BOOL)isUserTheLoggedInUser:(id)aUserOrAUserIdentifier
{
    if ([aUserOrAUserIdentifier isKindOfClass:[CPString class]])
    {
        // A userIdentifier was passed in. This is leftover from before, so handle it to be nice.
        return [[self userIdentifier] isEqualToString:aUserOrAUserIdentifier];
    }
    
    return (user === aUserOrAUserIdentifier);
}

@end

@implementation OLUserSessionManager (CPUserSessionManagerCompatibility)

- (void)setUserIdentifier:(CPString)anIdentifier
{
    CPLog.warn("%s is deprecated. Use - (void)setUser:(id)aUser instead.", _cmd);
}

- (CPString)userIdentifier
{
    if (user && [user respondsToSelector:@selector(userIdentifier)])
    {
        return [user userIdentifier];
    }
    
    return nil;
}

@end
