@import <AppKit/CPView.j>

@import "../Controllers/OLMessageController.j"

var OLMailViewFromColumnHeader = @"OLMailViewFromColumnHeader";
var OLMailViewSubjectColumnHeader = @"OLMailViewSubjectColumnHeader";
var OLMailViewDateColumnHeader = @"OLMailViewDateColumnHeader";

@implementation OLMailView : CPView
{
	CPTableView		tableView           @accessors(readonly);
	CPTextField     contentTextField    @accessors(readonly);
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		var scrollView = [[CPScrollView alloc] initWithFrame:frame];//change to the top half of the splitview
		[scrollView setAutohidesScrollers:YES];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[tableView setUsesAlternatingRowBackgroundColors:NO]; //Mail doesn't do this... should we?
		[tableView setAutoresizingMask:CPViewWidthSizable | CPViewWidthSizable];
			
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		[[tableView cornerView] setBackgroundColor:headerColor];
		
		// add the first column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewFromColumnHeader];
		[[column headerView] setStringValue:@"From"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:200.0];
		[tableView addTableColumn:column];
		
		var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewSubjectColumnHeader];
		[[column headerView] setStringValue:@"Subject"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:300.0];
		[tableView addTableColumn:column];
		
		var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewDateColumnHeader];
		[[column headerView] setStringValue:@"Date Received"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:CGRectGetWidth(frame)-500.0];
        
        var contentTextField = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame) / 2.0)];
        [self addSubview:contentTextField];
        
        [scrollView setDocumentView:tableView];
        [self addSubview:scrollView];
	}
	return self;
}

- (void)setCommunityController:(OLCommunityController)communityController
{
    [tableView setDataSource:communityController];
	[tableView setDelegate:communityController];
}

@end
