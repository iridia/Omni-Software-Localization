@implementation OLLineItem : CPObject
{
	CPString _identifier 	@accessors(readonly, property=identifier);
	CPObject _value 		@accessors(property=value);
}

- (id)initWithIdentifier:(CPString)anIdentifier withValue:(CPObject)aValue
{
	if(self = [super init])
	{
		_identifier = anIdentifier;
		_value = aValue;
	}
	return self;
}

@end

var OLLineItemIdentifierKey = @"OLLineItemIdentifierKey";
var OLLineItemValueKey = @"OLLineItemValueKey";

@implementation OLLineItem (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _identifier = [aCoder decodeObjectForKey:OLLineItemIdentifierKey];
        _value = [aCoder decodeObjectForKey:OLLineItemValueKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_identifier forKey:OLLineItemIdentifierKey];
    [aCoder encodeObject:_value forKey:OLLineItemValueKey];
}

@end
