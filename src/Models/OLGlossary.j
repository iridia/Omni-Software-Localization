@import "OLActiveRecord.j"

@implementation OLGlossary : OLActiveRecord
{
	CPArray		lineItems;
	CPString	name;
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