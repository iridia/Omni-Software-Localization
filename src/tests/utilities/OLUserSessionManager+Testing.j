@import "../../Utilities/OLUserSessionManager.j"

var OLDefaultUserSessionManager = nil;

@implementation OLUserSessionManager (Testing)

+ (id)defaultSessionManager
{
    if (!OLDefaultUserSessionManager)
    {
        OLDefaultUserSessionManager = [[OLUserSessionManager alloc] init];
    }
    
    return OLDefaultUserSessionManager;
}

+ (void)resetDefaultSessionManager
{
    OLDefaultUserSessionManager = nil;
}

@end