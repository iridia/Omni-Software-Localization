@import <Foundation/CPObject.j>
//@import "OLUserData.j"

@implementation OLUser : OLActiveRecord
{
	CPString _email @accessors(property=email, readonly);
	CPString _realNameFirst @accessors(property=firstName, readonly);
	CPString _realNameMiddle @accessors(property=middleName, readonly);
	CPString _realNameLast @accessors(property=lastName, readonly);
	
}


- (id)initWithEmail:(CPString)emailAddress
{
	return [self initWithEmail:emailAddress firstName:@"John" middleName:@"W." lastName:@"Doe"];
}


- (id)initWithEmail:(CPString)emailAddress firstName:(CPString)fName middleName:(CPstring)mName lastName:(CPString)lName
{
	self = [super init];
	
	if (self)
	{
		if ( isValidEmail(emailAddress) ) [self setEmail:emailAddress];
		else [self setEmail:nil];
		[self setFirstName:fName];
		[self setMiddleName:mName];
		[self setLastName:lName];
	}
	
	return self;
}


@end


var OLUserEmailKey = @"OLUserEmailKey";
var OLUserFirstNameKey = @"OLUserFirstNameKey";
var OLUserMiddleNameKey = @"OLUserMiddleNameKey";
var OLUserLastNameKey = @"OLUserLastNameKey";


@implementation OLUser (CPCoding)


- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		_email = [aCoder decodeObjectForKey:OLUserEmailKey];
		_realNameFirst = [aCoder decodeObjectForKey:OLUserFirstNameKey];
		_realNameMiddle = [aCoder decodeObjectForKey:OLUserMiddleNameKey];
		_realNameLast = [aCoder decodeObjectForKey:OLUserLastNameKey];
	}

	return self;
}


- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:_email forKey:OLUserEmailKey];
	[aCoder encodeObject:_realNameFirst forKey:OLUserFirstNameKey];
	[aCoder encodeObject:_realNameMiddle forKey:OLUserMiddleNameKey];
	[aCoder encodeObject:_realNameLast forKey:OLUserLastNameKey];
}

// this needs to be moved up out of the Coding category (can't do it in vim)
- (CPComparisonResult)compare:(OLUser)otherUser
{
	if ([self username] < [otherUser username])
		return CPOrderedAscending;
	else
		return CPOrderedDescending;
}



@end


function isValidEmail(anEmail)
{
	// check that it has the components of an email address
	// prefix - @ symbol - .something
	var regexp = /.+@.+\..+/;
	return anEmail.match(regexp);
}


