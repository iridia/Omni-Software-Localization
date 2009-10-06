@import <Foundation/CPObject.j>
@import "EJUser.j"

/*
 * Initalizes and tracks the users.
 */
@implementation EJUserController : CPObject
{
    CPArray _users @accessors(property=users, readonly);
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _users = [];
    }
    
    return self;
}

- (void)readUsersFromBundle
{    
    var bundle = [CPBundle mainBundle];
    var usersFromBundle = [bundle objectForInfoDictionaryKey:@"EJUsers"];
    
    for (var i = 0; i < [usersFromBundle count]; i++)
    {
        var user = [[EJUser alloc] initWithDictionary:[usersFromBundle objectAtIndex:i]];
        [self insertObject:user inUsersAtIndex:i];
    }
    
    // Want alphabetical order
    [_users sortUsingSelector:@selector(compare:)];
    
    var allUsers = [[EJUser alloc] initWithDictionary:[[CPDictionary alloc] initWithObjects:[@"All Users", nil] forKeys:[@"Display Name", @"Handles"]]];
    [self insertObject:allUsers inUsersAtIndex:[_users count]];
}

- (void)insertObject:(id)anObject inUsersAtIndex:(CPInteger)anIndex
{
    [_users addObject:anObject];
}

@end