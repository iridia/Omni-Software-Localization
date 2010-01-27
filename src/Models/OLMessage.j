@import "OLActiveRecord.j"
@import "OLUser.j"

@implementation OLMessage : OLActiveRecord
{
    CPString    subject         @accessors;
	CPString    content         @accessors;
	CPDate      dateSent        @accessors;
	CPArray     toUsers         @accessors;
	CPString    fromUserEmail   @accessors;   
}

- (id)init
{
    return [self initFromUser:nil toUsers:nil subject:@"" content:""];
}

- (id)initFromUser:(OLUser)from toUsers:(CPArray)to
{
    return [self initFromUser:from toUser:to subject:@"No Subject" content:@""];
}

- (id)initFromUser:(OLUser)from toUser:(OLUser)to subject:(CPString)aSubject content:(CPString)someContent
{
    return [self initFromUser:from toUsers:[[to userIdentifier]] subject:aSubject content:someContent];
}

- (id)initFromUser:(OLUser)from toUsers:(CPArray)to subject:(CPString)aSubject content:(CPString)someContent
{
    if(self = [super init])
	{
		fromUserEmail = [from email];
		
		toUsers = [];
		for (var i = 0; i < [to count]; i++)
		{
		    [toUsers addObject:[to objectAtIndex:i]];
		}
		
		subject = aSubject;
		content = someContent;
		dateSent = [CPDate date];
	}
	return self;
}

@end

var OLMessageFromUserEmailKey = @"OLMessageFromUserEmailKey";
var OLMessageSubjectKey = @"OLMessageSubjectKey";
var OLMessageContentKey = @"OLMessageContentKey";
var OLMessageDateSentKey = @"OLMessageDateSentKey";
var OLMessageToUsersKey = @"OLMessageToUsersKey";

@implementation OLMessage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		fromUserEmail = [aCoder decodeObjectForKey:OLMessageFromUserEmailKey];
        subject = [aCoder decodeObjectForKey:OLMessageSubjectKey];
        content = [aCoder decodeObjectForKey:OLMessageContentKey];
        dateSent = [aCoder decodeObjectForKey:OLMessageDateSentKey];
        toUsers = [aCoder decodeObjectForKey:OLMessageToUsersKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:fromUserEmail forKey:OLMessageFromUserEmailKey];
    [aCoder encodeObject:subject forKey:OLMessageSubjectKey];
    [aCoder encodeObject:content forKey:OLMessageContentKey];
    [aCoder encodeObject:dateSent forKey:OLMessageDateSentKey];
    [aCoder encodeObject:toUsers forKey:OLMessageToUsersKey];
}

@end
