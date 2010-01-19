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
    CPPopUpButton           resourceBundlesView;
    CPView                  votingView;
    
    BOOL                    isEditing               @accessors(readonly);
    
    id                      resourceBundleDelegate  @accessors;
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
		
		var voteUpButton = [CPButton buttonWithTitle:@"Vote Up"];
		[voteUpButton setAutoresizingMask:CPViewMaxXMargin];
        [voteUpButton setTarget:self];
        [voteUpButton setAction:@selector(voteUp:)];
        [votingView addSubview:voteUpButton positioned:CPViewLeftAligned | CPViewHeightCentered relativeTo:votingView withPadding:5.0];
        
        var voteDownButton = [CPButton buttonWithTitle:@"Vote Down"];
        [voteDownButton setAutoresizingMask:CPViewMaxXMargin];
        [voteDownButton setTarget:self];
        [voteDownButton setAction:@selector(voteDown:)];
        [votingView addSubview:voteDownButton positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:voteUpButton withPadding:5.0];
        
        [bottomView addSubview:votingView positioned:CPViewBottomAligned relativeTo:bottomView withPadding:0.0];
        
        // _votes = [CPTextField labelWithTitle:@"Votes: "];
        //         [_votes setFont:[CPFont systemFontOfSize:14.0]];
        //         [_votes sizeToFit];
        //         [_votes setAutoresizingMask:CPViewMaxXMargin];
        //         [_votes setFrameOrigin:CPMakePoint(CGRectGetWidth([voteUpButton bounds]) + CGRectGetWidth([voteDownButton bounds]) + 30.0, 7.0)];
        //         [bottomBar addSubview:_votes];
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

- (CPTableView)resourcesTableView
{
    return [resourcesTableView tableView];
}

- (CPTableView)lineItemsTableView
{
    return [lineItemsTableView tableView];
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
        return [splitView maxPossiblePositionOfDividerAtIndex:dividerIndex];
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