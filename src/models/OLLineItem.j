@implementation OLLineItem : CPObject
{
	CPString _identifier 	@accessors(readonly, property=identifier);
	CPObject _value 		@accessors(readonly, property=value);
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
