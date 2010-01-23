@import "OLActiveRecord.j"

@implementation OLMessage : OLActiveRecord
{
    CPString subject    @accessors;
	CPString content    @accessors;
	CPDate   dateSent   @accessors;
	CPString toUserID   @accessors;
	CPString fromUserID @accessors;  // could possibly change to the user object later (depending on session manager)
}

+ (void)findByToUserID:(CPString)toUserID callback:(Function)callback
{
    [self find:@"touserid" by:toUserID callback:callback];
}

- (id)initWithUserID:(CPString)aUserID to:(CPString)toID
{
    [self initWithUserID:aUserID subject:@"No Subject" content:@"" to:toID];
}

- (id)initWithUserID:(CPString)aUserID content:(CPString)someContent
{
	[self initWithUserID:aUserID subject:@"No Subject" content:someContent to:@"No one."];
}

- (id)initWithUserID:(CPString)fromID subject:(CPString)aSubject content:(CPString)someContent to:(CPString)toID
{
    if(self = [super init])
	{
		fromUserID = fromID;
		subject = aSubject;
		content = someContent;
		dateSent = [CPDate date];
		toUserID = toID;
	}
	return self;
}

@end

var OLMessageFromUserIDKey= @"OLMessageFromUserIDKey";
var OLMessageSubjectKey = @"OLMessageSubjectKey";
var OLMessageContentKey = @"OLMessageContentKey";
var OLMessageDateSentKey = @"OLMessageDateSentKey";
var OLMessageToUserIDKey = @"OLMessageToUserIDKey";

@implementation OLMessage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		fromUserID = [aCoder decodeObjectForKey:OLMessageFromUserIDKey];
        subject = [aCoder decodeObjectForKey:OLMessageSubjectKey];
        content = [aCoder decodeObjectForKey:OLMessageContentKey];
        dateSent = [aCoder decodeObjectForKey:OLMessageDateSentKey];
        toUserID = [aCoder decodeObjectForKey:OLMessageToUserIDKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:fromUserID forKey:OLMessageFromUserIDKey];
    [aCoder encodeObject:subject forKey:OLMessageSubjectKey];
    [aCoder encodeObject:content forKey:OLMessageContentKey];
    [aCoder encodeObject:dateSent forKey:OLMessageDateSentKey];
    [aCoder encodeObject:toUserID forKey:OLMessageToUserIDKey];
}

@end
