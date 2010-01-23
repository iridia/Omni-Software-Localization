@import <AppKit/CPView.j>

@import "../Categories/CPView+Positioning.j"
@import "OLTableView.j"
@import "OLNavigationBarView.j"

OLLineItemTableColumnIdentifierIdentifier = @"OLLineItemTableColumnIdentifierIdentifier";
OLLineItemTableColumnValueIdentifier = @"OLLineItemTableColumnValueIdentifier";

@implementation OLProjectView : CPView
{
    CPSplitView             splitView;
    OLTableView             resourcesTableView;
    OLTableView             lineItemsTableView;
    OLNavigationBarView     navigationBarView;
    CPTextField             backView;
    CPPopUpButton           resourceBundlesView;
    CPView                  votingView;
    
    CPButton                voteUpButton;
    CPButton                voteDownButton;
    CPTextField             votes;
    
    BOOL                    isEditing               @accessors(readonly);
    
    id                      resourceBundleDelegate  @accessors;
    
    id                      votingDataSource;
    id                      ownerDataSource;
    id                      titleDataSource;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        navigationBarView = [[OLNavigationBarView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 40.0)];
        [navigationBarView setAutoresizingMask:CPViewWidthSizable];
        [self addSubview:navigationBarView];
        
        resourceBundlesView = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 24.0)];
        [resourceBundlesView setTarget:self];
        [resourceBundlesView setAction:@selector(_selectedResourceBundleDidChange:)];
        [navigationBarView setAccessoryView:resourceBundlesView];

        [navigationBarView setBackView:[self backView]];
        
        splitView = [[CPSplitView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) - CGRectGetHeight([navigationBarView bounds]))];
        [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [splitView setVertical:NO];
        [splitView setDelegate:self];
        [self addSubview:splitView positioned:CPViewBelow relativeTo:navigationBarView withPadding:0.0];
        
        var resourceColumn = [[CPTableColumn alloc] initWithIdentifier:@"ResourceFileName"];
        [[resourceColumn headerView] setStringValue:@"Filename"];
        [resourceColumn setWidth:CGRectGetWidth(aFrame)];
        
        resourcesTableView = [[OLTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) / 2.0)
                                columns:[resourceColumn]];
        [resourcesTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [splitView addSubview:resourcesTableView];
    
        var bottomView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), (CGRectGetHeight(aFrame) / 2.0))];
        
        votingView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), 32.0)];
		[votingView setBackgroundColor:[CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/_CPToolbarViewBackground.png"]]]];
		[votingView setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
		
		voteUpButton = [CPButton buttonWithTitle:@"Vote Up"];
		[voteUpButton setAutoresizingMask:CPViewMaxXMargin];
        [voteUpButton setAction:@selector(voteUp:)];
        [votingView addSubview:voteUpButton positioned:CPViewLeftAligned | CPViewHeightCentered relativeTo:votingView withPadding:5.0];
        
        voteDownButton = [CPButton buttonWithTitle:@"Vote Down"];
        [voteDownButton setAutoresizingMask:CPViewMaxXMargin];
        [voteDownButton setAction:@selector(voteDown:)];
        [votingView addSubview:voteDownButton positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:voteUpButton withPadding:5.0];
        
        votes = [CPTextField labelWithTitle:@""];
        [votes setFont:[CPFont systemFontOfSize:14.0]];
        [votes sizeToFit];
        [votes setAutoresizingMask:CPViewMaxXMargin];
        [votingView addSubview:votes positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:voteDownButton withPadding:5.0];
        
        [bottomView addSubview:votingView positioned:CPViewBottomAligned relativeTo:bottomView withPadding:0.0];
        
    	var lineItemIdentifierColumn = [[CPTableColumn alloc] initWithIdentifier:OLLineItemTableColumnIdentifierIdentifier];
		[[lineItemIdentifierColumn headerView] setStringValue:@"Identifier"];
		[lineItemIdentifierColumn setWidth:200.0];

		var lineItemValueColumn = [[CPTableColumn alloc] initWithIdentifier:OLLineItemTableColumnValueIdentifier];
		[[lineItemValueColumn headerView] setStringValue:@"Value"];
		[lineItemValueColumn setWidth:(CGRectGetWidth(aFrame) - [lineItemIdentifierColumn width])];
        
        lineItemsTableView = [[OLTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), (CGRectGetHeight([bottomView bounds]) - CGRectGetHeight([votingView bounds])))
                                columns:[lineItemIdentifierColumn, lineItemValueColumn]];
        [lineItemsTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [bottomView addSubview:lineItemsTableView positioned:CPViewTopAligned relativeTo:bottomView withPadding:0.0];
        
        [splitView addSubview:bottomView];
        
        [self setIsEditing:NO];
    }
    return self;
}

- (CPView)backView
{
    backView = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    [backView setFont:[CPFont boldSystemFontOfSize:14.0]];
    [backView setTextShadowColor:[CPColor colorWithCalibratedWhite:240.0 / 255.0 alpha:1.0]];
    [backView setTextShadowOffset:CGSizeMake(0.0, 1)];
    [backView setTextColor:[CPColor colorWithCalibratedWhite:79.0 / 255.0 alpha:1.0]];
    
    return backView;
}

- (CPTableView)resourcesTableView
{
    return [resourcesTableView tableView];
}

- (CPTableView)lineItemsTableView
{
    return [lineItemsTableView tableView];
}

- (void)setVotingDelegate:(id)aDelegate
{
    [voteUpButton setTarget:aDelegate];
    [voteDownButton setTarget:aDelegate];
}

- (void)setVotingDataSource:(id)aDataSource
{
    votingDataSource = aDataSource;
}

- (void)setOwnerDataSource:(id)aDataSource
{
    ownerDataSource = aDataSource;
}

- (void)setTitleDataSource:(id)aDataSource
{
    titleDataSource = aDataSource;
}

- (void)reloadOwner
{
    if(ownerDataSource)
    {
        [backView setStringValue:[ownerDataSource owner]];
        [backView sizeToFit];
        [navigationBarView repositionBackView];
    }
}

- (void)reloadVoting
{
    if(votingDataSource)
    {
        [votes setStringValue:@"Votes: "+[votingDataSource numberOfVotesForSelectedResource]];
        [votes sizeToFit];
    }
}

- (void)setResourcesTableViewDelegate:(id)aDelegate
{
    [resourcesTableView setDelegate:aDelegate];
}

- (void)setResourcesTableViewDataSource:(id)aDataSource
{
    [resourcesTableView setDataSource:aDataSource];
}

- (void)selectResourcesTableViewRowIndexes:(CPIndexSet)rowIndexes byExtendingSelection:(BOOL)shouldExtendSelection
{
    [resourcesTableView selectRowIndexes:rowIndexes byExtendingSelection:shouldExtendSelection];
}

- (void)reloadResourcesTableView
{
    [resourcesTableView reloadData];
}

- (void)setLineItemsTableViewDelegate:(id)aDelegate
{
    [lineItemsTableView setDelegate:aDelegate];
}

- (void)setLineItemsTableViewDataSource:(id)aDataSource
{
    [lineItemsTableView setDataSource:aDataSource];
}

- (void)selectLineItemsTableViewRowIndexes:(CPIndexSet)rowIndexes byExtendingSelection:(BOOL)shouldExtendSelection
{
    [lineItemsTableView selectRowIndexes:rowIndexes byExtendingSelection:shouldExtendSelection];
}

- (void)reloadLineItemsTableView
{
    [lineItemsTableView reloadData];
}

- (void)setLineItemsTarget:(id)target doubleAction:(SEL)doubleAction
{
    [lineItemsTableView setTarget:target];
    [lineItemsTableView setDoubleAction:doubleAction];
}

- (void)reloadTitle
{
    if(titleDataSource)
    {
        [self setTitle:[titleDataSource title]];
    }
}

- (void)setTitle:(CPString)aTitle
{
    [navigationBarView setTitle:aTitle];
}

- (void)reloadAllData
{
    [resourcesTableView reloadData];
    [lineItemsTableView reloadData];
    
    if ([resourceBundleDelegate respondsToSelector:@selector(titlesOfResourceBundlesForProjectView:)])
    {
        var resourceBundles = [resourceBundleDelegate titlesOfResourceBundlesForProjectView:self];
        [resourceBundlesView removeAllItems];
        [resourceBundlesView addItemsWithTitles:resourceBundles];
        
        if ([resourceBundleDelegate respondsToSelector:@selector(indexOfSelectedResourceBundleForProjectView:)])
        {
            [resourceBundlesView selectItemAtIndex:[resourceBundleDelegate indexOfSelectedResourceBundleForProjectView:self]];
        }
    }
    
    [self reloadVoting];
    [self reloadOwner];
    [self reloadTitle];
}

- (void)setIsEditing:(BOOL)editing
{
    if (editing === isEditing)
        return;
    
    isEditing = editing;
    
    if (isEditing)
    {
        [self _showLineItemsTableView];
    }
    else
    {
        [self _hideLineItemsTableView];
    }
}

- (void)_showLineItemsTableView
{
    [splitView setPosition:([splitView minPossiblePositionOfDividerAtIndex:0] + 100.0) ofDividerAtIndex:0];
}

- (void)_hideLineItemsTableView
{
    [splitView setPosition:[splitView maxPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];
}

- (void)_selectedResourceBundleDidChange:(id)sender
{
    if ([resourceBundleDelegate respondsToSelector:@selector(selectedResourceBundleDidChange:)])
    {
        [resourceBundleDelegate selectedResourceBundleDidChange:[resourceBundlesView indexOfSelectedItem]];
    }
}

@end

@implementation OLProjectView (CPSplitViewDelegate)

- (BOOL)splitView:(CPSplitView)splitView canCollapseSubview:(CPView)subview
{
    return isEditing;
}

- (BOOL)splitView:(CPSplitView)splitView shouldCollapseSubview:(CPView)subview forDoubleClickOnDividerAtIndex:(int)index
{
    return isEditing;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{
    if (!isEditing)
    {
        return proposedMin;
    }
    
    return proposedMin + 150.0;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    if (!isEditing)
    {
        return proposedMax;
    }
    
    return proposedMax - 150.0;
}

@end