@import <AppKit/CPTableView.j>

@implementation OLFilterTableView : CPTableView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var filterTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"filterColumn"];
		[filterTableColumn setWidth: CGRectGetWidth([self bounds])];
		[self addTableColumn: filterTableColumn];
		[self setUsesAlternatingRowBackgroundColors:YES];
		[self setRowHeight:50];
	}
	return self;
}

- (CPString)expectedDataFromResource:(OLResource)resource
{
	return [[resource tags] objectAtIndex:0];
}

@end
