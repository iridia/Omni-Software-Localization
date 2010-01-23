@import <AppKit/CPView.j>

@implementation OLTableView : CPView
{
    CPTableView     tableView       @accessors(readonly);
    SEL             doubleAction    @accessors;
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

@end

@implementation OLTableView (Forwarding)

- (CPMethodSignature)methodSignatureForSelector:(SEL)aSelector
{
    if ([tableView respondsToSelector:aSelector])
    {
        return YES;
    }
    
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(CPInvocation)anInvocation
{
    var selector = [anInvocation selector];
    if ([tableView respondsToSelector:selector])
    {
        [anInvocation invokeWithTarget:tableView];
    }
    else
    {
        [super forwardInvocation:anInvocation];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([tableView respondsToSelector:aSelector])
    {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}

@end

@implementation CPTableView (DoubleClick)

- (SEL)doubleAction
{
    if ([_delegate respondsToSelector:@selector(doubleAction)])
    {
        return [_delegate doubleAction];
    }
    
    return nil;
}

- (void)mouseDown:(CPEvent)anEvent
{
    if ([self target] && [self doubleAction] && [anEvent clickCount] == 2)
	{
		var index = [[self selectedRowIndexes] firstIndex];
		
		if(index >= 0)
		{
			[[self target] performSelector:[self doubleAction] withObject:self];	
		}
	}

	[super mouseDown:anEvent];
}

@end
