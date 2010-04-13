@import "OLActiveRecord.j"

@implementation OLGlossary : OLActiveRecord
{
	CPArray		lineItems;
	CPString	name        @accessors(readonly);
}

- (id)init
{
	return [self initWithName:@"Default"];
}

- (id)initWithName:(CPString)aName
{
	if (self = [super init])
	{
		name = aName;
		lineItems = [CPArray array];
	}
	
	return self;
}

- (void)addLineItem:(OLLineItem)aLineItem
{
	[lineItems addObject:aLineItem];
}

- (CPArray)lineItems
{
    return [lineItems copy];
}

- (CPString)sidebarName
{
    return [self name];
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
	[aCoder encodeObject:[self lineItems] forKey:OLGlossaryLineItemsKey];
    [aCoder encodeObject:[self name] forKey:OLGlossaryNameKey];
}

@end