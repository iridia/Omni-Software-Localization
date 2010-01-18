@import <OJMoq/OJMoq.j>

@import "../Utilities/OLUserSessionManager.j"
@import "utilities/Observer.j"

@implementation OLUserSessionManagerTest : OJTestCase
{
    Observer observer;
}

- (void)setUp
{
    observer = [[Observer alloc] init];
}

- (void)testThatOLUserSessionManagerDoesInitialize
{
    var target = [OLUserSessionManager defaultSessionManager];
    
    [self assertNotNull:target];
    [self assert:OLUserSessionUndeterminedStatus equals:[target status]];
}

- (void)testThatOLUserSessionManagerIsASingleton
{
    var first = [OLUserSessionManager defaultSessionManager];
    var second = [OLUserSessionManager defaultSessionManager];
    
    [self assert:first equals:second];
}

- (void)testThatOLUserSessionManagerDoesSetStatus
{
    var target = [OLUserSessionManager defaultSessionManager];
    
    [target setStatus:OLUserSessionLoggedInStatus];
    [self assert:OLUserSessionLoggedInStatus equals:[target status]];
}

- (void)testThatOLUserSessionManagerDoesSetStatusAndPostNotification
{
    var target = [OLUserSessionManager defaultSessionManager];
    
    // Clear status
    [target setStatus:OLUserSessionUndeterminedStatus];
    
    [observer startObserving:OLUserSessionManagerStatusDidChangeNotification];
    [target setStatus:OLUserSessionLoggedOutStatus];
    [self assertTrue:[observer didObserve:OLUserSessionManagerStatusDidChangeNotification]];
    
    // Shouldn't send it if it is the same as before
    [observer clearObservations:OLUserSessionManagerStatusDidChangeNotification];
    [target setStatus:OLUserSessionLoggedOutStatus];
    [self assertFalse:[observer didObserve:OLUserSessionManagerStatusDidChangeNotification]];
}

- (void)testThatOLUserSessionManagerDoesSetUser
{
    var target = [OLUserSessionManager defaultSessionManager];
    
    var object = [[CPObject alloc] init];
    
    [target setUser:object];
    [self assert:object equals:[target user]];
}

- (void)testThatOLUserSessionManagerDoesSetUserAndPostNotification
{
    var target = [OLUserSessionManager defaultSessionManager];
    
    var clearUser = [[CPObject alloc] init];
    // Clear status
    [target setUser:clearUser];
    
    var user = [[CPObject alloc] init];
    [observer startObserving:OLUserSessionManagerUserDidChangeNotification];
    [target setUser:user];
    [self assertTrue:[observer didObserve:OLUserSessionManagerUserDidChangeNotification]];
    
    // Shouldn't send it if it is the same user as before
    [observer clearObservations:OLUserSessionManagerUserDidChangeNotification];
    [target setUser:user];
    [self assertFalse:[observer didObserve:OLUserSessionManagerStatusDidChangeNotification]];
}

- (void)testThatOLUserSessionManagerMaintainsCompatibilityWithCPUserSessionManager
{
    var target = [OLUserSessionManager defaultSessionManager];
    
    [self assertTrue:[target respondsToSelector:@selector(userIdentifier)]];
    [self assertTrue:[target respondsToSelector:@selector(setUserIdentifier:)]];
    
    var user = moq();
    [user selector:@selector(userIdentifier) returns:@"1234"];
    
    [target setUser:user];
    [self assert:@"1234" equals:[target userIdentifier]];
}

@end