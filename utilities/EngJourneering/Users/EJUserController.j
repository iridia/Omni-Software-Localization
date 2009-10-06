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
        
        var bundle = [CPBundle mainBundle];
        var usersFromBundle = [bundle objectForInfoDictionaryKey:@"EJUsers"];
        
        for (var i = 0; i < [usersFromBundle count]; i++)
        {
            var user = [[EJUser alloc] initWithDictionary:[usersFromBundle objectAtIndex:i]];
            [_users addObject:user];
        }
        
        // Want alphabetical order
        [_users sortUsingSelector:@selector(compare:)];
    }
    
    return self;
}