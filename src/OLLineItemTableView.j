@import <AppKit/CPTableView.j>

@implementation OLLineItemTableView : CPTableView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var lineItemTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"lineItemColumn"];
		[lineItemTableColumn setWidth: CGRectGetWidth([self bounds])];
		[self addTableColumn: lineItemTableColumn];
		[self setUsesAlternatingRowBackgroundColors:YES];
	}
	return self;
}

- (CPString)expectedDataFromResource:(OLResource)resource
{
	return [resource fileType];
}

@end
