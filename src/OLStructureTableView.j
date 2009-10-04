@import <AppKit/CPTableView.j>

@implementation OLStructureTableView : CPTableView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var structureTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"structureColumn"];
		[structureTableColumn setWidth: CGRectGetWidth([self bounds])];
		[self addTableColumn: structureTableColumn];
		[self setUsesAlternatingRowBackgroundColors:YES];
	}
	return self;
}

- (CPString)expectedDataFromResource:(OLResource)resource
{
	return [resource fileType];
}

@end
