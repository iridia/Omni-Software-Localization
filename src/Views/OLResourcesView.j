@import <AppKit/CPSplitView.j>

@import "OLResourceEditorView.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";
var OLResourcesViewVoteColumn = @"OLResourcesViewVoteColumn";

@implementation OLResourcesView : CPSplitView
{
    CPTableView             resourceTableView   @accessors(property=resourceTableView);
    OLResourceEditorView    editingView         @accessors(property=editingView, readonly);
    OLResourceController    resourceController;
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
        // [self addSubview:editingView];
	}

	return self;
}

- (void)setResourceController:(OLResourceController)aResourceController
{
    [resourceTableView setDataSource:aResourceController];
    [resourceTableView setDelegate:aResourceController];
    resourceController = aResourceController;
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
    if (![editingView isDescendantOf:self])
    {
        [self addSubview:editingView];
        [self setNeedsDisplay:YES];
    }
}

- (void)hideLineItemsTableView
{
    if ([editingView isDescendantOf:self])
    {
        [editingView removeFromSuperview];
        [self setNeedsDisplay:YES];
    }
}

- (void)reloadVotes
{
    [[editingView votes] setStringValue:@"Votes: " + [[resourceController selectedResource] numberOfVotes]];
    [[editingView votes] sizeToFit];
}

@end

@implementation OLResourcesView (CPSplitViewDelegate)

- (BOOL)splitView:(CPSplitView)splitView canCollapseSubview:(CPView)subview
{
    return YES;
}

- (BOOL)splitView:(CPSplitView)splitView shouldCollapseSubview:(CPView)subview forDoubleClickOnDividerAtIndex:(int)index
{
    return YES;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{    
    return proposedMin + 150.0;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    return proposedMax - 150.0;
}

@end