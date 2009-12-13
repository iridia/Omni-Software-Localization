@import <AppKit/CPSplitView.j>

@import "OLResourceEditorView.j"

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";
var OLResourcesViewVoteColumn = @"OLResourcesViewVoteColumn";

@implementation OLResourcesView : CPSplitView
{
	id _delegate @accessors(property=delegate);
    CPArray     _resources @accessors(property=resources);
    CPTableView _resourceTableView @accessors(property=resourceTableView);
    
    OLResourceController        resourceController;

    OLResourceEditorView _editingView   @accessors(property=editingView, readonly);
    BOOL _isEditing @accessors(property=isEditing);
}

- (id)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
	    [self setVertical:NO];
	    
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
		// create the resourceTableView
		_resourceTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[_resourceTableView setUsesAlternatingRowBackgroundColors:YES];
		[_resourceTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		
		[[_resourceTableView cornerView] setBackgroundColor:headerColor];
		
		// add the filename column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourcesViewFileNameColumn];
		[[column headerView] setStringValue:"Filename"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:CGRectGetWidth(aFrame)];
		[_resourceTableView addTableColumn:column];
		
		[scrollView setDocumentView:_resourceTableView];
		
		[self addSubview:scrollView];

        // Create the editingView up front, show it when needed
		_editingView = [[OLResourceEditorView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) / 2.0)];
		[_editingView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	}

	return self;
}

- (void)setResourceController:(OLResourceController)aResourceController
{
    [_resourceTableView setDataSource:aResourceController];
    [_resourceTableView setDelegate:aResourceController];
}

- (void)setLineItemController:(OLLineItemsController)aLineItemsController
{
    [[_editingView lineItemsTableView] setDataSource:aLineItemsController];
    [[_editingView lineItemsTableView] setDelegate:aLineItemsController];
    [[_editingView lineItemsTableView] setTarget:aLineItemsController];
	[[_editingView lineItemsTableView] setDoubleAction:@selector(editSelectedLineItem:)];
}

- (void)showLineItemsTableView
{
    if (![_editingView isDescendantOf:self])
    {
        [self addSubview:_editingView];
        [self setNeedsDisplay:YES];
    }
}

- (void)hideLineItemsTableView
{
    if ([_editingView isDescendantOf:self])
    {
        [_editingView removeFromSuperview];
        [self setNeedsDisplay:YES];
    }
}

@end