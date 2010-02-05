@import "OLActiveRecord.j"

@implementation OLUser : OLActiveRecord
{
	CPString _email         @accessors(property=email, readonly);
    CPString nickname       @accessors;
    CPString userLocation   @accessors;
    CPArray  languages      @accessors;
    CPString bio            @accessors;
}

- (id)initWithEmail:(CPString)emailAddress
{
	self = [super init];

	if (self)
	{
		if ( isValidEmail(emailAddress) )
		{
			_email = emailAddress;
			nickname=@"";
			userLocation=@"";
			languages=[CPArray array];
			bio=@"";
		}
	}

	return self;
}

- (id)initWithEmail:(CPString)email Nickname:(CPString)aNickname Location:(CPString)aUserLocation Languages:(OLLanguage)someLanguages Bio:(CPString)aBio
{
    self = [super init];
    
    if(self)
    {
        if( isValidEmail(email))
        {
            _email = email;
            nickname = aNickname;
            userLocation = aUserLocation;
            languages=someLanguages;
            bio=aBio;
        }
    }
    return self;
}

@end

var OLUserEmailKey = @"OLUserEmailKey";
var OLUserLocationKey = @"OLUserLocationKey";
var OLUserNicknameKey = @"OLUserNicknameKey";
var OLUserLanguagesKey = @"OLUserLangaugesKey";
var OLUserBioKey = @"OLUserBioKey";

@implementation OLUser (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
	self = [super init];

	if (self)
	{
		_email = [aCoder decodeObjectForKey:OLUserEmailKey];
        userLocation = [aCoder decodeObjectForKey:OLUserLocationKey];
        nickname = [aCoder decodeObjectForKey:OLUserNicknameKey];
        languages = [aCoder decodeObjectForKey:OLUserLanguagesKey];
        bio = [aCoder decodeObjectForKey:OLUserBioKey];
	}

	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:_email forKey:OLUserEmailKey];
    [aCoder encodeObject:userLocation forKey:OLUserLocationKey];
    [aCoder encodeObject:nickname forKey:OLUserNicknameKey];
    [aCoder encodeObject:languages forKey:OLUserLanguagesKey];
    [aCoder encodeObject:bio forKey:OLUserBioKey];
}

@end

@implementation OLUser (OLUserSessionManager)

- (CPString)userIdentifier
{
    return [self recordID];
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
