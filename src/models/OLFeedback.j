@import "OLActiveRecord.j"

@implementation OLFeedback : OLActiveRecord
{
    CPString _email;
    CPString _type;
    CPString _text;
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
        _email = [aCoder decodeObjectForKey:OLFeedbackEmailKey];
        _type = [aCoder decodeObjectForKey:OLFeedbackTypeKey];
        _text = [aCoder decodeObjectForKey:OLFeedbackTextKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObjectForKey:OLFeedbackEmailKey];
    [aCoder encodeObjectForKey:OLFeedbackTypeKey];
    [aCoder encodeObjectForKey:OLFeedbackTextKey];
}

@end