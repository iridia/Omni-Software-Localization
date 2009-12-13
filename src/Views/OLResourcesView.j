@import <AppKit/CPSplitView.j>

@import "OLResourceEditorView.j"

// FIXME: THIS IS ACTUALLY A BUNDLES VIEW

var OLResourcesViewFileNameColumn = @"OLResourcesViewFileNameColumn";
var OLResourcesViewVoteColumn = @"OLResourcesViewVoteColumn";

@implementation OLResourcesView : CPSplitView
{
	id _delegate @accessors(property=delegate);
    CPArray     _resources @accessors(property=resources);
    CPTableView _resourceTableView @accessors(property=resourceTableView);
    
    OLResourceController        resourceController;

    OLResourceEditorView _editingView;
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
        // [_resourceTableView setDataSource:self];
		[_resourceTableView setUsesAlternatingRowBackgroundColors:YES];
		[_resourceTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        // [_resourceTableView setDelegate:self];
		
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

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    if (keyPath === @"bundles")
    {
        _resources = [object bundles];
        [_resourceTableView reloadData];
    }
}

- (void)setResourceController:(OLResourceController)aResourceController
{
    if (aResourceController !== resourceController)
    {
        resourceController = aResourceController;
        [_resourceTableView setDataSource:resourceController];
        [_resourceTableView setDelegate:resourceController];
    }
}

- (void)setDelegate:(id)aDelegate
{
    if (aDelegate !== _delegate)
    {
        // _delegate = aDelegate;
        // [_delegate addObserver:_editingView forKeyPath:@"editingBundle" options:CPKeyValueObservingOptionNew context:nil];
        // [_delegate addObserver:_editingView forKeyPath:@"editingBundle.resources" options:CPKeyValueObservingOptionNew context:nil];
        // [_editingView setDelegate:_delegate];
    }
}

@end

@implementation OLResourcesView (CPTableViewDelegate)

- (void)tableViewSelectionDidChange:(CPNotification)aNotification
{
    var index = [[[aNotification object] selectedRowIndexes] firstIndex];
    
    if (index < 0)
    {
        if (_isEditing)
        {
            [_editingView removeFromSuperview];
            self._needsResizeSubviews = YES;
            [self setNeedsDisplay:YES];
        }
        
        [self setIsEditing:NO];
    }
    else
    {
        if (!_isEditing)
        {
            [self addSubview:_editingView];
            [self setNeedsDisplay:YES];
            [self setIsEditing:YES];
        }
    
        [_delegate didSelectBundleAtIndex:index];
    }
    
    // [_editingView deselectRow]; Probably want to do something along these lines
}

@end

@implementation CPTableView (DoubleClick)

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent clickCount] == 2)
	{
		var index = [[self selectedRowIndexes] firstIndex];
		
		if(index >= 0)
		{
			objj_msgSend([self target], [self doubleAction], self);	
		}
	}


	[super mouseDown:anEvent];
}

@end