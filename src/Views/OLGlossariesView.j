@import <AppKit/CPView.j>
@import "OLTableView.j"

var OLGlossaryViewIdentifierColumnHeader = @"OLGlossaryViewIdentifierColumnHeader";
var OLGlossaryViewValueColumnHeader = @"OLGlossaryViewValueColumnHeader";

@implementation OLGlossariesView : CPView
{
	CPTableView		    tableView   @accessors(readonly);
	OLNavigationBarView titleView;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
        var titleViewBorder = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 41.0)];
        [titleViewBorder setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [titleViewBorder setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:titleViewBorder];
        
        titleView = [[OLNavigationBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(frame), 40.0)];
        [titleView setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:titleView positioned:CPViewTopAligned relativeTo:self withPadding:0.0];
    
		// add the first column
		var columnOne = [[CPTableColumn alloc] initWithIdentifier:OLGlossaryViewIdentifierColumnHeader];
		[[columnOne headerView] setStringValue:@"Identifier"];
		[columnOne setWidth:200.0];
		
		var columnTwo = [[CPTableColumn alloc] initWithIdentifier:OLGlossaryViewValueColumnHeader];
		[[columnTwo headerView] setStringValue:@"Value"];
		[columnTwo setWidth:(CGRectGetWidth(frame) - 200.0)];
		
		tableView = [[OLTableView alloc] initWithFrame:CGRectMake(0.0, 42.0, CGRectGetWidth(frame), CGRectGetHeight(frame)-42) columns:[columnOne, columnTwo]];
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

- (void)setTitle:(CPString)aTitle
{
    [titleView setTitle:aTitle];
}

@end