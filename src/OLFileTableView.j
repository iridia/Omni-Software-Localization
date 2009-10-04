@import <AppKit/CPTableView.j>

/*!
 * A view for displaying available localizable resource files.
 */
@implementation OLFileTableView : CPTableView
{
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		var filesTableColumn = [[CPTableColumn alloc] initWithIdentifier:@"filesColumn"];
		[filesTableColumn setWidth: CGRectGetWidth([self bounds])];
		[self addTableColumn: filesTableColumn];
		[self setUsesAlternatingRowBackgroundColors:YES];
	}
	return self;
}

- (CPString)expectedDataFromResource:(OLResource)resource
{
	return [resource fileName];
}

@end
