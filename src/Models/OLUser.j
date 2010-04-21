@import "OLActiveRecord.j"

@implementation OLUser : OLActiveRecord
{
	CPString    email   @accessors(readonly);
}

- (id)initWithEmail:(CPString)emailAddress
{
	if (self = [super init])
	{
	    email = emailAddress;
	}
	return self;
}

@end


var OLUserEmailKey = @"OLUserEmailKey";

@implementation OLUser (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		email = [aCoder decodeObjectForKey:OLUserEmailKey];
	}

	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:[self email] forKey:OLUserEmailKey];
}

@end


@implementation OLUser (OLUserSessionManager)

- (CPString)userIdentifier
{
    return [self recordID];
}

@end
