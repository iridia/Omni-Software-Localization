@import "OLActiveRecord.j"

@implementation OLFeedback : OLActiveRecord
{
    CPString    email   @accessors;
    CPString    type    @accessors;
    CPString    text    @accessors;
}

- (id)init
{
    [self initWithEmail:@"example@email.com" type:@"default" text:@"default"];
}

- (id)initWithEmail:(CPString)anEmail type:(CPString)aType text:(CPString)someText
{
    self = [super init];
    
    if (self)
    {
        [self setEmail:anEmail];
        [self setType:aType];
        [self setText:someText];
    }
    
    return self;
}

@end

var OLFeedbackEmailKey = @"OLFeedbackEmailKey";
var OLFeedbackTypeKey = @"OLFeedbackTypeKey";
var OLFeedbackTextKey = @"OLFeedbackTextKey";

@implementation OLFeedback (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        [self setEmail:[aCoder decodeObjectForKey:OLFeedbackEmailKey]];
        [self setType:[aCoder decodeObjectForKey:OLFeedbackTypeKey]];
        [self setText:[aCoder decodeObjectForKey:OLFeedbackTextKey]];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:[self email] forKey:OLFeedbackEmailKey];
    [aCoder encodeObject:[self type] forKey:OLFeedbackTypeKey];
    [aCoder encodeObject:[self text] forKey:OLFeedbackTextKey];
}

@end