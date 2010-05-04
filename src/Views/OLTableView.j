@import <AppKit/CPView.j>
@import "../Utilities/OLConstants.j"

@implementation OLTableView : CPView
{
    CPTableView     tableView       @accessors(readonly);
}

- (id)initWithFrame:(CGRect)aFrame columns:(CPArray)columns
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame))];
        [scrollView setAutohidesScrollers:YES];

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

@implementation CPTableView (Resonder)

- (BOOL)becomeFirstResponder
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLTableViewBecameFirstResponder
        object:self];
        
    [self unsetThemeState:CPThemeStateInactive];
    [self _updateRowsAsActive];

    return YES;
}

- (BOOL)resignFirstResponder
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLTableViewResignedFirstResponder
        object:self];   
        
    [self setThemeState:CPThemeStateInactive];
    [self _updateRowsAsInactive];
    
    return YES;
}

@end
