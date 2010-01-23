@import "OLActiveRecord.j"
@import "OLUser.j"

@implementation OLMessage : OLActiveRecord
{
    CPString    subject         @accessors;
	CPString    content         @accessors;
	CPDate      dateSent        @accessors;
	CPString    toUserID        @accessors;
	CPString    fromUserID      @accessors;
	CPString    fromUserEmail   @accessors;   
}

+ (void)findByToUserID:(CPString)toUserID callback:(Function)callback
{
    [self find:@"touserid" by:toUserID callback:callback];
}

- (id)init
{
    return [self initFromUser:nil toUser:nil subject:@"" content:""];
}

- (id)initFromUser:(OLUser)from toUser:(OLUser)to
{
    return [self initFromUser:from toUser:to subject:@"No Subject" content:@""];
}

- (id)initFromUser:(OLUser)from toUser:(OLUser)to subject:(CPString)aSubject content:(CPString)someContent
{
    if(self = [super init])
	{
		fromUserID = [from userIdentifier];
		fromUserEmail = [from email];
		toUserID = [to userIdentifier];
		subject = aSubject;
		content = someContent;
		dateSent = [CPDate date];
	}
	return self;
}

@end

var OLMessageFromUserIDKey= @"OLMessageFromUserIDKey";
var OLMessageFromUserEmailKey = @"OLMessageFromUserEmailKey";
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
		fromUserEmail = [aCoder decodeObjectForKey:OLMessageFromUserEmailKey];
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
	[aCoder encodeObject:fromUserEmail forKey:OLMessageFromUserEmailKey];
    [aCoder encodeObject:subject forKey:OLMessageSubjectKey];
    [aCoder encodeObject:content forKey:OLMessageContentKey];
    [aCoder encodeObject:dateSent forKey:OLMessageDateSentKey];
    [aCoder encodeObject:toUserID forKey:OLMessageToUserIDKey];
}

@end
