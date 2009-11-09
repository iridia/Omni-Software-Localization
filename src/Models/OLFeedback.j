@import "OLActiveRecord.j"

@implementation OLFeedback : OLActiveRecord
{
    CPString _email @accessors(property=email);
    CPString _type @accessors(property=type);
    CPString _text @accessors(property=text);
}

- (id)init
{
    [self initWithEmail:nil type:nil text:nil];
}

- (id)initWithEmail:(CPString)email type:(CPString)type text:(CPString)text
{
    self = [super init];
    
    if (self)
    {
        _email = email;
        _type = type;
        _text = text;
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
        _email = [aCoder decodeObjectForKey:OLFeedbackEmailKey];
        _type = [aCoder decodeObjectForKey:OLFeedbackTypeKey];
        _text = [aCoder decodeObjectForKey:OLFeedbackTextKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_email forKey:OLFeedbackEmailKey];
    [aCoder encodeObject:_type forKey:OLFeedbackTypeKey];
    [aCoder encodeObject:_text forKey:OLFeedbackTextKey];
}

@end