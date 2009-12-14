@import "OLActiveRecord.j"

@implementation OLGlossary : OLActiveRecord
{
	CPArray		lineItems   @accessors(readonly);
	CPString	name        @accessors(readonly);
}

-(id)init
{
	return [self initWithName:@"TestingName"];
}

-(id)initWithName:(CPString)aName
{
	if (self = [super init])
	{
		name = aName;
		lineItems = [CPArray array];
	}
	
	return self;
}

-(void)addLineItem:(OLLineItem)aLineItem
{
	[lineItems addObject:aLineItem];
}

@end

var OLGlossaryLineItemsKey = @"OLGlossaryLineItemsKey";
var OLGlossaryNameKey = @"OLGlossaryNameKey";

@implementation OLGlossary (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		lineItems = [aCoder decodeObjectForKey:OLGlossaryLineItemsKey];
        name = [aCoder decodeObjectForKey:OLGlossaryNameKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:lineItems forKey:OLGlossaryLineItemsKey];
    [aCoder encodeObject:name forKey:OLGlossaryNameKey];
}

@end