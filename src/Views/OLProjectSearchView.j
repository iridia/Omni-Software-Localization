@import <AppKit/CPView.j>
@import <AppKit/CPTableView.j>

@implementation OLProjectSearchView : CPView
{
    OLTableView allProjectsTableView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
    	var column = [[CPTableColumn alloc] initWithIdentifier:@"ProjectName"];
    	[[column headerView] setStringValue:"Project Name"];
    	[column setWidth:CGRectGetWidth(aFrame)/3];
    	
        var ownerColumn = [[CPTableColumn alloc] initWithIdentifier:@"OwnerName"];
        [[ownerColumn headerView] setStringValue:"Owner Name"];
        [ownerColumn setWidth:CGRectGetWidth(aFrame)/3];
    	
    	var votesColumn = [[CPTableColumn alloc] initWithIdentifier:@"TotalVotes"];
    	[[votesColumn headerView] setStringValue:"Total Votes"];
    	[votesColumn setWidth:CGRectGetWidth(aFrame)/3];
    	
		allProjectsTableView = [[OLTableView alloc] initWithFrame:aFrame columns:[column,ownerColumn,votesColumn]];
		[allProjectsTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
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

@end
