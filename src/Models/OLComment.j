@import "OLActiveRecord.j"
@import "OLUser.j"

@implementation OLComment : OLActiveRecord
{
	CPString    content         @accessors;
	CPDate      date            @accessors;
	CPString    type            @accessors;
	CPString    objectID        @accessors;
	CPString    userID          @accessors;
}

- (id)init
{
    return [self initFromUser:nil withContent:@"" forObject:nil];
}

- (id)initFromUser:(OLUser)user withContent:(CPString)someContent forObject:(id)anObject
{
    if (self = [super init])
    {
        date = [CPDate date];
        type = [[anObject class] databaseName];
        objectID = [anObject recordID];
        userID = [user recordID];
        content = someContent;
    }
    return self;
}

@end


var OLCommentContentKey = @"OLCommentContentKey";
var OLCommentDateKey = @"OLCommentDateKey";
var OLCommentTypeKey = @"OLCommentTypeKey";
var OLCommentObjectIDKey = @"OLCommentObjectIDKey";
var OLCommentUserIDKey = @"OLCommentUserIDKey";

@implementation OLComment (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        content = [aCoder decodeObjectForKey:OLCommentContentKey];
        date = [aCoder decodeObjectForKey:OLCommentDateKey];
        type = [aCoder decodeObjectForKey:OLCommentTypeKey];
        objectID = [aCoder decodeObjectForKey:OLCommentObjectIDKey];
        userID = [aCoder decodeObjectForKey:OLCommentUserIDKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:content forKey:OLCommentContentKey];
    [aCoder encodeObject:date forKey:OLCommentDateKey];
    [aCoder encodeObject:type forKey:OLCommentTypeKey];
    [aCoder encodeObject:objectID forKey:OLCommentObjectIDKey];
    [aCoder encodeObject:userID forKey:OLCommentUserIDKey];
}

@end
