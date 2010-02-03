@import <AppKit/CPView.j>
@import "OLTableView.j"

@implementation OLProjectDashboardView : CPView
{
    CPTextField         name;
    CPTextField         subscribers;
    
    OLTableView         branchesTableView   @accessors(readonly);
    
    CPView              commentsView;
    CPCollectionView    collectionView;
    
    id                  delegate;
    
    id                  tabs;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        tabs = [[CPTabView alloc] initWithFrame:CGRectInset(aFrame, 50, 50)];
        [tabs setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        var summaryTab = [[CPTabViewItem alloc] initWithIdentifier:@"summary"];
        [summaryTab setLabel:@"Summary"];
        
        var summaryView = [[CPView alloc] initWithFrame:CGRectMakeZero()];

        var nameLabel = [CPTextField labelWithTitle:@"Name:"];
        var subscribersLabel = [CPTextField labelWithTitle:@"Subscribers:"];
        
        name = [CPTextField labelWithTitle:@""];
        subscribers = [CPTextField labelWithTitle:@""];
        
        [summaryView addSubview:nameLabel positioned:CPViewLeftAligned | CPViewTopAligned relativeTo:summaryView withPadding:50.0];
        [summaryView addSubview:subscribersLabel positioned:CPViewBelow | CPViewLeftSame relativeTo:nameLabel withPadding:10.0];
        
        [summaryView addSubview:subscribers positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:subscribersLabel withPadding:5.0];
        [summaryView addSubview:name positioned:CPViewAbove | CPViewLeftSame relativeTo:subscribers withPadding:10.0];
        
        [summaryTab setView:summaryView];
        
        var branchesTab = [[CPTabViewItem alloc] initWithIdentifier:@"branches"];
        [branchesTab setLabel:@"Branches"];
        
        var ownerColumn = [[CPTableColumn alloc] initWithIdentifier:@"owner"];
        [ownerColumn setWidth:0];
        [[ownerColumn headerView] setStringValue:@"Owner"];
        [ownerColumn setResizingMask:CPTableColumnAutoresizingMask];
        var nameColumn = [[CPTableColumn alloc] initWithIdentifier:@"name"];
        [nameColumn setWidth:0];
        [[nameColumn headerView] setStringValue:@"Project Name"];
        [nameColumn setResizingMask:CPTableColumnAutoresizingMask];
        var votesColumn = [[CPTableColumn alloc] initWithIdentifier:@"votes"];
        [votesColumn setWidth:0];
        [[votesColumn headerView] setStringValue:@"Votes"];
        [votesColumn setResizingMask:CPTableColumnAutoresizingMask];
        
        var containerView = [[CPView alloc] initWithFrame:CGRectMake(0,0,100,100)];
        branchesTableView = [[OLTableView alloc] initWithFrame:CGRectInset([containerView frame], 10, 10) columns:[ownerColumn, nameColumn, votesColumn]];
        [branchesTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[branchesTableView setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];
        
        [containerView addSubview:branchesTableView];
        
        [branchesTab setView:containerView];
        
        var commentsTab = [[CPTabViewItem alloc] initWithIdentifier:@"comments"];
        [commentsTab setLabel:@"Comments"];
        
        commentsView = [[CPView alloc] initWithFrame:[tabs bounds]];
        [commentsView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([tabs bounds]), CGRectGetWidth([tabs bounds]) - 170.0)];
        [scrollView setAutohidesScrollers:YES];

        var prototype = [[CPCollectionViewItem alloc] init];
        [prototype setView:[[OLCommentView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([scrollView bounds]), 70.0)]];
        
        collectionView = [[CPCollectionView alloc] initWithFrame:[scrollView bounds]];
        [collectionView setItemPrototype:prototype];
        [collectionView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [collectionView setMaxNumberOfColumns:1];
        [collectionView setVerticalMargin:10.0];
        [collectionView setMinItemSize:CPMakeSize(100.0, 50.0)];
        [collectionView setMaxItemSize:CPMakeSize(10000.0, 50.0)];
        
        [scrollView setDocumentView:collectionView];
        [commentsView addSubview:scrollView];
        
        [commentsTab setView:scrollView];
        
        [tabs addTabViewItem:summaryTab];
        [tabs addTabViewItem:branchesTab];
        [tabs addTabViewItem:commentsTab];
        
        [self addSubview:tabs];
    }
    return self;
}

- (void)setDelegate:(id)aDelegate
{
    [branchesTableView setDataSource:aDelegate];
    delegate = aDelegate;
}

- (void)reloadData:(id)sender
{
    [branchesTableView reloadData];
    [name setStringValue:[delegate projectName]];
    [name sizeToFit];
    [subscribers setStringValue:[delegate subscribers]];
    [subscribers sizeToFit];
	[collectionView setContent:[delegate comments]];
	[collectionView reloadContent];
}

@end
