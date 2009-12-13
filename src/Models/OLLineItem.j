@import "OLActiveRecord.j"

@implementation OLLineItem : OLActiveRecord
{
	CPString comment		@accessors(readonly);
	CPString identifier 	@accessors(readonly);
	CPObject value	 		@accessors;
}

- (id)initWithIdentifier:(CPString)anIdentifier value:(CPObject)aValue
{
	[self initWithIdentifier:anIdentifier value:aValue comment:@"No Comment"];
}

- (id)initWithIdentifier:(CPString)anIdentifier value:(CPObject)aValue comment:(CPString)aComment
{
	if(self = [super init])
	{
		comment = aComment;
		identifier = anIdentifier;
		value = aValue;
	}
	return self;
}

@end

var OLLineItemCommentKey = @"OLLineItemCommentKey";
var OLLineItemIdentifierKey = @"OLLineItemIdentifierKey";
var OLLineItemValueKey = @"OLLineItemValueKey";

@implementation OLLineItem (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		comment = [aCoder decodeObjectForKey:OLLineItemCommentKey];
        identifier = [aCoder decodeObjectForKey:OLLineItemIdentifierKey];
        value = [aCoder decodeObjectForKey:OLLineItemValueKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:comment forKey:OLLineItemCommentKey];
    [aCoder encodeObject:identifier forKey:OLLineItemIdentifierKey];
    [aCoder encodeObject:value forKey:OLLineItemValueKey];
}

@end
