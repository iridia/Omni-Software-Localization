@import <AppKit/CPSplitView.j>
@import "OLSourceView.j"

@implementation OLMainView : CPSplitView
{
    CPView _currentView;
	id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setIsPaneSplitter:YES];
        [self setVertical:YES];
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var sourceView = [[OLSourceView alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight(frame))];
        [sourceView setBackgroundColor:[CPColor sourceViewColor]];
        [sourceView setAutoresizingMask:CPViewHeightSizable | CPViewMaxXMargin];

        [self addSubview:sourceView];
		[sourceView setDelegate:self];

        _currentView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) - 200, CGRectGetHeight(frame))];
        [_currentView setBackgroundColor:[CPColor lightGrayColor]];
        [_currentView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

        [self addSubview:_currentView];
    }
    
    return self;
}	

- (void)selectedResourcesList:(id)sender
{
	if([_delegate respondsToSelector:@selector(selectedResourcesList:)])
	{
		[_delegate selectedResourcesList:sender];
	}
}

- (void)setCurrentView:(CPView)newView
{    
    [self replaceSubview:_currentView with:newView];
    
    _currentView = newView;
}

- (CGRect)currentViewFrame
{
    return [_currentView frame];
}

@end