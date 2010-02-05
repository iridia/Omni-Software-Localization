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
        var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame))];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setHasHorizontalScroller:NO];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        tableView = [[CPTableView alloc] initWithFrame:CGRectMakeZero(0, 0, 500, 500)];
		[tableView setUsesAlternatingRowBackgroundColors:YES];
        [tableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[tableView setColumnAutoresizingStyle:CPTableViewLastColumnOnlyAutoresizingStyle];

		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		
		for (var i = 0; i < [columns count]; i++)
		{
		    var column = [columns objectAtIndex:i];
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
    if ([super respondsToSelector:aSelector])
    {
        return YES;
    }
    
    if ([tableView respondsToSelector:aSelector])
    {
        return YES;
    }
    
    return NO;
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

- (BOOL)becomeFirstResponder
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLTableViewBecameFirstResponder"
        object:self];

    return YES;
}

- (BOOL)resignFirstResponder
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLTableViewResignedFirstResponder"
        object:self];   

    return YES;
}

@end
