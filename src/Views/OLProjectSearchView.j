@import <AppKit/CPView.j>
@import <AppKit/CPTableView.j>

@implementation OLProjectSearchView : CPView
{
    OLTableView     allProjectsTableView;
    CPSearchField   searchField             @accessors(readonly);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var titleViewBorder = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 41.0)];
        [titleViewBorder setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [titleViewBorder setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:titleViewBorder];
        
        var titleView = [[OLNavigationBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 40.0)];
        [titleView setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:titleView positioned:CPViewTopAligned relativeTo:self withPadding:0.0];
        
        [titleView setTitle:@"Search Public Projects"];
        
        searchField = [[CPSearchField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 30.0)];
        [titleView setAccessoryView:searchField];
        [searchField setTarget:self];
        [searchField setTag:@"search"];
        [searchField setAction:@selector(searchDidUpdate:)];
    
    	var column = [[CPTableColumn alloc] initWithIdentifier:@"ProjectName"];
    	[[column headerView] setStringValue:"Project Name"];
    	[column setWidth:CGRectGetWidth(aFrame)/3];
    	
        var ownerColumn = [[CPTableColumn alloc] initWithIdentifier:@"OwnerName"];
        [[ownerColumn headerView] setStringValue:"Owner Name"];
        [ownerColumn setWidth:CGRectGetWidth(aFrame)/3];
    	
    	var votesColumn = [[CPTableColumn alloc] initWithIdentifier:@"TotalVotes"];
    	[[votesColumn headerView] setStringValue:"Total Votes"];
    	[votesColumn setWidth:CGRectGetWidth(aFrame)/3];
    	
		allProjectsTableView = [[OLTableView alloc] initWithFrame:CGRectMake(0.0, 42.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame)-42.0) columns:[column,votesColumn]];
		[allProjectsTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[[allProjectsTableView tableView] setTag:@"search_results"];
		
		[self addSubview:allProjectsTableView];
    }
    return self;
}

- (CPTableView)allProjectsTableView
{
    return [allProjectsTableView tableView];
}

- (void)setDataSource:(id)aDataSource
{
    [allProjectsTableView setDataSource:aDataSource];
}

- (void)setDelegate:(id)aDelegate
{
    [allProjectsTableView setTarget:aDelegate];
    [allProjectsTableView setDelegate:aDelegate];
}

- (void)reloadData
{
    [allProjectsTableView reloadData];
}

- (void)searchDidUpdate:(id)sender
{
    [self reloadData];
}

@end
