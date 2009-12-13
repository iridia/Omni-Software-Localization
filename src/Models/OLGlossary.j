@import "OLActiveRecord.j"

@implementation OLGlossary : OLActiveRecord
{
	CPArray listOfLineItems;
	CPString glossaryName;
}

-(id)init
{
	return [self initWithName:@"TestingName"];
}

-(id)initWithName:(CPString)aName
{
	if (self = [super init])
	{
		glossaryName = aName;
		listOfLineItems = [CPArray array];
	}
	
	return self;
}

-(void)addLineItem:(OLLineItem)aLineItem
{
	[listOfLineItems addObject:aLineItem];
}

@end