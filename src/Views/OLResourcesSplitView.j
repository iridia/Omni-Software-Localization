@import <AppKit/CPSplitView.j>

@import "OLResourceEditorView.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";
var OLResourcesViewVoteColumn = @"OLResourcesViewVoteColumn";

@implementation OLResourcesSplitView : CPSplitView
{
    CPTableView             resourceTableView   @accessors(readonly);
    OLResourceEditorView    editingView         @accessors(readonly);
    BOOL                    isEditing;
}

- (id)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
	    [self setVertical:NO];
	    [self setDelegate:self];
	    
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
		// create the resourceTableView
		resourceTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[resourceTableView setUsesAlternatingRowBackgroundColors:YES];
		[resourceTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		
		[[resourceTableView cornerView] setBackgroundColor:headerColor];
		
		// add the filename column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourcesViewFileNameColumn];
		[[column headerView] setStringValue:"Filename"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:CGRectGetWidth(aFrame)];
		[resourceTableView addTableColumn:column];
		
		[scrollView setDocumentView:resourceTableView];
		
		[self addSubview:scrollView];

        // Create the editingView up front, show it when needed
		editingView = [[OLResourceEditorView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) / 2.0)];
		[editingView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [self addSubview:editingView];
        [self setPosition:[self maxPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];
	}

	return self;
}

- (void)setResourceController:(OLResourceController)aResourceController
{
    [resourceTableView setDataSource:aResourceController];
    [resourceTableView setDelegate:aResourceController];
}

- (void)setLineItemController:(OLLineItemsController)aLineItemsController
{
    [[editingView lineItemsTableView] setDataSource:aLineItemsController];
    [[editingView lineItemsTableView] setDelegate:aLineItemsController];
    [[editingView lineItemsTableView] setTarget:aLineItemsController];
	[[editingView lineItemsTableView] setDoubleAction:@selector(editSelectedLineItem:)];
}

- (void)showLineItemsTableView
{
    if (!isEditing)
    {
        isEditing = YES;
        [self setPosition:([self maxPossiblePositionOfDividerAtIndex:0] - 150.0) ofDividerAtIndex:0];
    }
}

- (void)hideLineItemsTableView
{
    isEditing = NO;
    [self setPosition:[self maxPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];
}

- (void)setVoteCount:(int)votes
{
    [[editingView votes] setStringValue:@"Votes: " + votes];
    [[editingView votes] sizeToFit];
}

@end

@implementation OLResourcesSplitView (CPSplitViewDelegate)

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
        return [self maxPossiblePositionOfDividerAtIndex:dividerIndex];
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