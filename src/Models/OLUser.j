@import "OLActiveRecord.j"

@implementation OLUser : OLActiveRecord
{
	CPString _email @accessors(property=email, readonly);
	
}


- (id)initWithEmail:(CPString)emailAddress
{
	self = [super init];

	if (self)
	{
		if ( isValidEmail(emailAddress) )
		{
			_email = emailAddress;
		}
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
		_email = [aCoder decodeObjectForKey:OLUserEmailKey];
	}

	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:_email forKey:OLUserEmailKey];
}

@end

function isValidEmail(anEmail)
{
	try
	{
		// check that it has the components of an email address
		// prefix - @ symbol - .something
		var regexp = ".+@.+\..+";
		return anEmail.match(regexp);
	}
	catch(ex)
	{
		return NO;
	}
}
