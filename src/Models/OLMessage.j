@import "OLActiveRecord.j"
@import "OLUser.j"

@implementation OLMessage : OLActiveRecord
{
    CPString    subject         @accessors;
	CPString    content         @accessors;
	CPDate      dateSent        @accessors(readonly);
	CPArray     receivers       @accessors(readonly);
	CPString    senderEmail     @accessors(readonly);   
}

- (id)init
{
    return [self initWithSender:nil receivers:[] subject:@"" content:@""];
}

- (id)initWithSender:(OLUser)aSender receivers:(CPArray)someReceivers subject:(CPString)aSubject content:(CPString)someContent
{
    if (self = [super init])
	{
		senderEmail = [aSender email];
		receivers = [someReceivers copy];
		subject = aSubject;
		content = someContent;
		dateSent = [CPDate date];
	}
	return self;
}

@end


var OLMessageSenderEmailKey = @"OLMessageSenderEmailKey";
var OLMessageSubjectKey = @"OLMessageSubjectKey";
var OLMessageContentKey = @"OLMessageContentKey";
var OLMessageDateSentKey = @"OLMessageDateSentKey";
var OLMessageReceiversKey = @"OLMessageReceiversKey";

@implementation OLMessage (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		senderEmail = [aCoder decodeObjectForKey:OLMessageSenderEmailKey];
        subject = [aCoder decodeObjectForKey:OLMessageSubjectKey];
        content = [aCoder decodeObjectForKey:OLMessageContentKey];
        dateSent = [aCoder decodeObjectForKey:OLMessageDateSentKey];
        receivers = [aCoder decodeObjectForKey:OLMessageReceiversKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:[self senderEmail] forKey:OLMessageSenderEmailKey];
    [aCoder encodeObject:[self subject] forKey:OLMessageSubjectKey];
    [aCoder encodeObject:[self content] forKey:OLMessageContentKey];
    [aCoder encodeObject:[self dateSent] forKey:OLMessageDateSentKey];
    [aCoder encodeObject:[self receivers] forKey:OLMessageReceiversKey];
}

@end
