@import "OLActiveRecord.j"

@implementation OLUser : OLActiveRecord
{
	CPString email          @accessors(readonly);
    CPString nickname       @accessors;
    CPString userLocation   @accessors;
    CPArray  languages      @accessors;
    CPString bio            @accessors;
}

- (id)initWithEmail:(CPString)emailAddress
{
	return [self initWithEmail:emailAddress nickname:@"" location:@"" languages:[CPArray array] bio:@""];
}

- (id)initWithEmail:(CPString)anEmail nickname:(CPString)aNickname location:(CPString)aUserLocation languages:(OLLanguage)someLanguages bio:(CPString)aBio
{
    self = [super init];
    
    if(self)
    {
        if (isValidEmail(anEmail))
        {
            email = anEmail;
            nickname = aNickname;
            userLocation = aUserLocation;
            languages = someLanguages;
            bio = aBio;
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
		email = [aCoder decodeObjectForKey:OLUserEmailKey];
        userLocation = [aCoder decodeObjectForKey:OLUserLocationKey];
        nickname = [aCoder decodeObjectForKey:OLUserNicknameKey];
        languages = [aCoder decodeObjectForKey:OLUserLanguagesKey];
        bio = [aCoder decodeObjectForKey:OLUserBioKey];
	}

	return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:email forKey:OLUserEmailKey];
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
