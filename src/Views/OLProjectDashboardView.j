@import <AppKit/CPView.j>
@import "OLTableView.j"

@implementation OLProjectDashboardView : CPView
{
    CPTextField         name;
    CPTextField         subscribers;
    
    OLTableView         branchesTableView;
    
    CPView              commentsView;
    CPCollectionView    collectionView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var tabs = [[CPTabView alloc] initWithFrame:CGRectInset(aFrame, 50, 50)];
        [tabs setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        var summaryTab = [[CPTabViewItem alloc] initWithIdentifier:@"summary"];
        [summaryTab setLabel:@"Summary"];
        
        var summaryView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
        [summaryView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

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
        
        branchesTableView = [[OLTableView alloc] initWithFrame:CGRectInset([tabs bounds], 100, 100)];
		[branchesTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [branchesTab setView:branchesTableView];
        
        var commentsTab = [[CPTabViewItem alloc] initWithIdentifier:@"comments"];
        [commentsTab setLabel:@"Comments"];
        
        commentsView = [[CPView alloc] initWithFrame:[tabs bounds]];
        [commentsView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([tabs bounds]), CGRectGetWidth([tabs bounds]) - 170.0)];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

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

@end
