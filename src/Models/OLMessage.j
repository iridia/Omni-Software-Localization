@import "OLActiveRecord.j"

@implementation OLMessage : OLActiveRecord
{
    CPString subject @accessors;
	CPString content @accessors;
	CPString fromUserID @accessors;  // could possibly change to the user object later (depending on session manager)
}

- (id)initWithUserID:(CPString)aUserID
{
    [self initWithUserID:aUserID subject:@"No Subject" content:@""];
}

- (id)initWithUserID:(CPString)aUserID content:(CPString)someContent
{
	[self initWithUserID:aUserID subject:@"No Subject" content:someContent];
}

- (id)initWithUserID:(CPString)aUserID subject:(CPString)aSubject content:(CPString)someContent
{
    if(self = [super init])
	{
		fromUserID = aUserID;
		subject = aSubject;
		content = someContent;
	}
	return self;
}

@end

var OLMessageFromUserIDKey= @"OLMessageFromUserIDKey";
var OLMessageSubjectKey = @"OLMessageSubjectKey";
var OLMessageContentKey = @"OLMessageContentKey";

@implementation OLMessage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		fromUserID = [aCoder decodeObjectForKey:OLMessageFromUserIDKey];
        subject = [aCoder decodeObjectForKey:OLMessageSubjectKey];
        content = [aCoder decodeObjectForKey:OLMessageContentKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:fromUserID forKey:OLMessageFromUserIDKey];
    [aCoder encodeObject:subject forKey:OLMessageSubjectKey];
    [aCoder encodeObject:content forKey:OLMessageContentKey];
}

@end
