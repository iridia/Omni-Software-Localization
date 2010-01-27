@import <AppKit/CPView.j>
@import "OLTableView.j"

var OLGlossaryViewIdentifierColumnHeader = @"OLGlossaryViewIdentifierColumnHeader";
var OLGlossaryViewValueColumnHeader = @"OLGlossaryViewValueColumnHeader";

@implementation OLGlossariesView : CPView
{
	CPTableView		tableView   @accessors(readonly);
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		// add the first column
		var columnOne = [[CPTableColumn alloc] initWithIdentifier:OLGlossaryViewIdentifierColumnHeader];
		[[columnOne headerView] setStringValue:@"Identifier"];
		[columnOne setWidth:200.0];
		
		var columnTwo = [[CPTableColumn alloc] initWithIdentifier:OLGlossaryViewValueColumnHeader];
		[[columnTwo headerView] setStringValue:@"Value"];
		[columnTwo setWidth:(CGRectGetWidth(frame) - 200.0)];
		
		tableView = [[OLTableView alloc] initWithFrame:frame columns:[columnOne, columnTwo]];
    	[tableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		[self addSubview:tableView];
	}
	return self;
}

- (void)setGlossaryController:(OLGlossaryController)glossaryController
{
	[tableView setDataSource:glossaryController];
	[tableView setDelegate:glossaryController];
}

@end