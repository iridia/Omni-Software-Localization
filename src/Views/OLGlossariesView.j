@import <AppKit/CPView.j>

var OLGlossaryViewIdentifierColumnHeader = @"OLGlossaryViewIdentifierColumnHeader";
var OLGlossaryViewValueColumnHeader = @"OLGlossaryViewValueColumnHeader";

@implementation OLGlossariesView : CPView
{
	CPTableView		tableView;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		var scrollView = [[CPScrollView alloc] initWithFrame:frame];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[tableView setUsesAlternatingRowBackgroundColors:YES];
		[tableView setAutoresizingMask:CPViewWidthSizable | CPViewWidthSizable];
				
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		[[tableView cornerView] setBackgroundColor:headerColor];
		
		// add the first column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLGlossaryViewIdentifierColumnHeader];
		[[column headerView] setStringValue:@"Identifier"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:200.0];
		[tableView addTableColumn:column];
		
		var column = [[CPTableColumn alloc] initWithIdentifier:OLGlossaryViewValueColumnHeader];
		[[column headerView] setStringValue:@"Value"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:(CGRectGetWidth(frame) - 200.0)];
		[tableView addTableColumn:column];
		
		[scrollView setDocumentView:tableView];
		[self addSubview:scrollView];
	}
	return self;
}

- (void)setGlossaryController:(OLGlossaryController)glossaryController
{
	[tableView setDataSource:glossaryController];
	[tableView setDelegate:glossaryController];
}

@end