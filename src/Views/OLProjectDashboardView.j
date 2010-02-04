@import <AppKit/CPView.j>
@import "OLTableView.j"

@implementation OLProjectDashboardView : CPView
{
    CPTextField         name;
    
    OLTableView         subscribers         @accessors(readonly);
    
    OLTableView         branchesTableView   @accessors(readonly);
    
    CPView              commentsView;
    CPCollectionView    collectionView;
    
    id                  delegate;
    
    id                  tabs;
    
    CPView              focusRing;
    CPView              subscribersFocusRing;
    CPView              navigationBarView;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(tableViewBecameFirstResponder:)
            name:@"OLTableViewBecameFirstResponder"
            object:nil];
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(tableViewResignedFirstResponder:)
            name:@"OLTableViewResignedFirstResponder"
            object:nil];
        
        navigationBarView = [[OLNavigationBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 40.0)];
        [navigationBarView setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:navigationBarView];
        
        var navBarBorder = [[CPView alloc] initWithFrame:CGRectMake(0.0, 40.0, CGRectGetWidth(aFrame), 1.0)];
        [navBarBorder setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [navBarBorder setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:navBarBorder];
        
        var toResourcesButton = [CPButton buttonWithTitle:@"To Resources"];
        [navigationBarView setAccessoryView:toResourcesButton];
        
        var tabsPreFrame = CGRectMake(0.0, 40.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) - 40.0);
                
        tabs = [[CPTabView alloc] initWithFrame:CGRectInset(tabsPreFrame, 50, 50)];
        [tabs setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        var summaryTab = [[CPTabViewItem alloc] initWithIdentifier:@"summary"];
        [summaryTab setLabel:@"Summary"];
        
        var summaryView = [[CPView alloc] initWithFrame:[tabs bounds]];
        
        var nameLabel = [CPTextField labelWithTitle:@"Name:"];
        var descriptionLabel = [CPTextField labelWithTitle:@"Description:"];
        
        [nameLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
        [descriptionLabel setFont:[CPFont boldSystemFontOfSize:14.0]];
        
        [nameLabel sizeToFit];
        [descriptionLabel sizeToFit];
        
        name = [CPTextField labelWithTitle:@""];
        description = [CPTextField labelWithTitle:@""];
        
        [name setFont:[CPFont boldSystemFontOfSize:32.0]];
        
        var subscriberColumn = [[CPTableColumn alloc] initWithIdentifier:@"subscriber"];
        [subscriberColumn setWidth:0];
        [[subscriberColumn headerView] setStringValue:@"Subscriber"];
        [subscriberColumn setResizingMask:CPTableColumnAutoresizingMask];
        
        subscribers = [[OLTableView alloc] initWithFrame:CGRectMake(0, 0, 300, 260) columns:[subscriberColumn]];
        [subscribers setAutoresizingMask:CPViewMinXMargin | CPViewHeightSizable];
        [subscribers setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];
        
        [summaryView addSubview:nameLabel positioned:CPViewLeftAligned | CPViewTopAligned relativeTo:summaryView withPadding:50.0];
        [summaryView addSubview:descriptionLabel positioned:CPViewLeftSame | CPViewBelow relativeTo:nameLabel withPadding:100.0];
        [summaryView addSubview:description positioned:CPViewHeightSame | CPViewOnTheRight relativeTo:descriptionLabel withPadding:10.0];
        [summaryView addSubview:name positioned:CPViewLeftSame | CPViewBelow relativeTo:nameLabel withPadding:30.0];
        [name setFrameOrigin:CGPointMake([name frame].origin.x + 20.0, [name frame].origin.y)];
        
        var subscribersBorderView = [[CPView alloc] initWithFrame:CGRectMake(49, 49, 302.0, 262.0)];
        [subscribersBorderView setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [subscribersBorderView setAutoresizingMask:CPViewMinXMargin | CPViewHeightSizable];
        
        subscribersFocusRing = [self focusRingAroundFrame:[subscribersBorderView frame]];
        [subscribersFocusRing setAutoresizingMask:CPViewMinXMargin | CPViewHeightSizable];
        
        [summaryView addSubview:subscribersFocusRing];
        [summaryView addSubview:subscribersBorderView];
        [summaryView addSubview:subscribers positioned:CPViewRightAligned | CPViewTopAligned relativeTo:summaryView withPadding:50.0];
        
        var downloadButton = [CPButton buttonWithTitle:@"Download"];
        var importButton   = [CPButton buttonWithTitle:@"Import"];
        
        [downloadButton setAutoresizingMask:CPViewMaxXMargin | CPViewMinYMargin];
        [importButton setAutoresizingMask:CPViewMaxXMargin | CPViewMinYMargin];
        
        [summaryView addSubview:downloadButton positioned:CPViewLeftAligned | CPViewBottomAligned relativeTo:summaryView withPadding:50.0];
        [summaryView addSubview:importButton positioned:CPViewHeightSame | CPViewOnTheRight relativeTo:downloadButton withPadding:12.0];
        
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
        
        var containerView = [[CPView alloc] initWithFrame:[tabs bounds]];
        
        branchesTableView = [[OLTableView alloc] initWithFrame:CGRectInset([containerView bounds], 20.0, 20.0) columns:[ownerColumn, nameColumn, votesColumn]];
        [branchesTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [branchesTableView setColumnAutoresizingStyle:CPTableViewUniformColumnAutoresizingStyle];
        
        var borderView = [[CPView alloc] initWithFrame:CGRectInset([containerView bounds], 19.0, 19.0)];
        [borderView setBackgroundColor:[CPColor colorWithHexString:@"7F7F7F"]];
        [borderView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        focusRing = [self focusRingAroundFrame:[borderView frame]];
        [focusRing setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [containerView addSubview:focusRing];
        [containerView addSubview:borderView];
        
        [containerView addSubview:branchesTableView];
        
        [branchesTab setView:containerView];
        
        var commentsTab = [[CPTabViewItem alloc] initWithIdentifier:@"comments"];
        [commentsTab setLabel:@"Comments"];
        
        commentsView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

        var scrollView = [[CPScrollView alloc] initWithFrame:CGRectInset([commentsView bounds], 20.0, 20.0)];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [scrollView setAutohidesScrollers:YES];

        var prototype = [[CPCollectionViewItem alloc] init];
        var prototypeView = [[OLCommentView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([scrollView bounds]), 50.0)];
        [prototype setView:prototypeView];
        
        collectionView = [[CPCollectionView alloc] initWithFrame:[scrollView bounds]];
        [collectionView setItemPrototype:prototype];
        [collectionView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [collectionView setMaxNumberOfColumns:1];
        [collectionView setVerticalMargin:10.0];
        [collectionView setMinItemSize:CPMakeSize(100.0, 50.0)];
        [collectionView setMaxItemSize:CPMakeSize(10000.0, 50.0)];
        
        [scrollView setDocumentView:collectionView];
        [commentsView addSubview:scrollView];
        
        [commentsTab setView:commentsView];
        
        [tabs addTabViewItem:summaryTab];
        [tabs addTabViewItem:branchesTab];
        [tabs addTabViewItem:commentsTab];
        
        [self addSubview:tabs];
        
        [subscribersFocusRing setHidden:YES];
        [focusRing setHidden:YES];
    }
    return self;
}

- (void)tableViewBecameFirstResponder:(CPNotification)aNotification
{
    var tableView = [aNotification object]; 

    if(tableView === [subscribers tableView])
    {
        [subscribersFocusRing setHidden:NO];
    }
    else
    {
        [focusRing setHidden:NO];
    }
}

- (void)tableViewResignedFirstResponder:(CPNotification)aNotification
{
    var tableView = [aNotification object];
    
    if(tableView === [subscribers tableView])
    {
        [subscribersFocusRing setHidden:YES];
    }
    else
    {
        [focusRing setHidden:YES];
    }
}

- (void)setDelegate:(id)aDelegate
{
    [branchesTableView setDataSource:aDelegate];
    [subscribers setDataSource:aDelegate];
    delegate = aDelegate;
}

- (void)reloadData:(id)sender
{
    [branchesTableView reloadData];
    [subscribers reloadData];
    [name setStringValue:[delegate projectName]];
    [name sizeToFit];
	[collectionView setContent:[delegate comments]];
	[collectionView reloadContent];
	[navigationBarView setTitle:@"Test.app"];
}

- (CPView)focusRingAroundFrame:(CGRect)frame
{
    var result = [[CPView alloc] initWithFrame:CGRectInset(frame, -4, -4)];
    
    var ninePartImage = [[CPNinePartImage alloc] initWithImageSlices:[
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-0.png" size:CGSizeMake(6.0, 7.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-1.png" size:CGSizeMake(1.0, 7.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-2.png" size:CGSizeMake(6.0, 7.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-3.png" size:CGSizeMake(6.0, 1.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-4.png" size:CGSizeMake(1.0, 1.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-5.png" size:CGSizeMake(6.0, 1.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-6.png" size:CGSizeMake(6.0, 5.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-7.png" size:CGSizeMake(1.0, 5.0)],
                            [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/textfield-bezel-square-focused-8.png" size:CGSizeMake(6.0, 5.0)],
                         ]];
    var patternColor = [CPColor colorWithPatternImage:ninePartImage];
    
    
    [result setBackgroundColor:patternColor];
    
    return result;
}

@end
