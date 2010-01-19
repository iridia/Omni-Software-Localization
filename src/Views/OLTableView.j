@import <AppKit/CPView.j>

@implementation OLTableView : CPView
{
    CPTableView     tableView   @accessors(readonly);
}

- (id)initWithFrame:(CGRect)aFrame columns:(CPArray)columns
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[tableView setUsesAlternatingRowBackgroundColors:YES];
		[tableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		[[tableView cornerView] setBackgroundColor:headerColor];
		
		for (var i = 0; i < [columns count]; i++)
		{
		    var column = [columns objectAtIndex:i];
		    [[column headerView] setBackgroundColor:headerColor];
		    [tableView addTableColumn:column];
		}
		
		[scrollView setDocumentView:tableView];
		
		[self addSubview:scrollView];
    }
    return self;
}

- (void)reloadData
{
    [tableView reloadData];
}

- (void)setDataSource:(id)aDataSource
{
    [tableView setDataSource:aDataSource];
}

- (void)setDelegate:(id)aDelegate
{
    [tableView setDelegate:aDelegate];
}

- (void)setTarget:(id)aTarget
{
    [tableView setTarget:aTarget];
}

- (void)setDoubleAction:(SEL)doubleAction
{
    [tableView setDoubleAction:doubleAction];
}

- (void)selectRowIndexes:(CPIndexSet)indexSet byExtendingSelection:(BOOL)shouldExtendSelection
{
    [tableView selectRowIndexes:indexSet byExtendingSelection:shouldExtendSelection];
}

@end

@implementation CPTableView (DoubleClick)

- (SEL)doubleAction
{
    return [_delegate doubleAction];
}

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
