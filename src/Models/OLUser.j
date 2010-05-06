@import "OLActiveRecord.j"

@implementation OLUser : OLActiveRecord
{
	CPString    openID      @accessors(readonly);
	CPString    username    @accessors(readonly);
}

- (id)initWithOpenID:(CPString)anOpenID username:(CPString)anUsername
{
	if (self = [super init])
	{
	    openID = anOpenID;
	    username = anUsername;
	}
	return self;
}

- (CPString)email
{
    CPLog(@"email is depecrated. use username.");
    
    return [self username];
}

@end


var OLUserOpenIDKey = @"OLUserOpenIDKey";
var OLUserNameKey = @"OLUserNameKey";

@implementation OLUser (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		openID = [aCoder decodeObjectForKey:OLUserOpenIDKey];
		username = [aCoder decodeObjectForKey:OLUserNameKey];
	}

	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:[self openID] forKey:OLUserOpenIDKey];
	[aCoder encodeObject:[self username] forKey:OLUserNameKey];
}

@end


@implementation OLUser (OLUserSessionManager)

- (CPString)userIdentifier
{
    return [self recordID];
}

@end
