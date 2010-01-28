@import "OLActiveRecord.j"
@import "OLUser.j"

@implementation OLComment : OLActiveRecord
{
	CPString    content         @accessors;
	CPDate      date            @accessors;
	CPString    userID          @accessors;
	CPString    userEmail       @accessors;
}

- (id)init
{
    return [self initFromUser:nil withContent:@""];
}

- (id)initFromUser:(OLUser)user withContent:(CPString)someContent
{
    if (self = [super init])
    {
        date = [CPDate date];
        userID = [user recordID];
        userEmail = [user email];
        content = someContent;
    }
    return self;
}

@end


var OLCommentContentKey = @"OLCommentContentKey";
var OLCommentDateKey = @"OLCommentDateKey";
var OLCommentUserIDKey = @"OLCommentUserIDKey";
var OLCommentUserEmailKey = @"OLCommentUserEmailKey";

@implementation OLComment (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        content = [aCoder decodeObjectForKey:OLCommentContentKey];
        date = [aCoder decodeObjectForKey:OLCommentDateKey];
        userID = [aCoder decodeObjectForKey:OLCommentUserIDKey];
        userEmail = [aCoder decodeObjectForKey:OLCommentUserEmailKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:content forKey:OLCommentContentKey];
    [aCoder encodeObject:date forKey:OLCommentDateKey];
    [aCoder encodeObject:userID forKey:OLCommentUserIDKey];
    [aCoder encodeObject:userEmail forKey:OLCommentUserEmailKey];
}

@end
