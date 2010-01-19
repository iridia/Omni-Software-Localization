@import <AppKit/CPView.j>
@import <AppKit/CPTableView.j>

@implementation ProjectSearchView : CPView
{
    CPTableView allProjectsTableView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
		// create the resourceTableView
		allProjectsTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[allProjectsTableView setUsesAlternatingRowBackgroundColors:YES];
		[allProjectsTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		
		[[allProjectsTableView cornerView] setBackgroundColor:headerColor];
		
		// add the filename column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLProjectNameColumn];
		[[column headerView] setStringValue:"Project Name"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:CGRectGetWidth(aFrame)];
		[allProjectsTableView addTableColumn:column];
		
		[scrollView setDocumentView:allProjectsTableView];
    }
    return self;
}

- (void)setDataSource:(id)aDataSource
{
    [allProjectsTableView setDataSource:aDataSource];
}

@end
