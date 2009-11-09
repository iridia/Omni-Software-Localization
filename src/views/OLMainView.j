@import <AppKit/CPSplitView.j>

@implementation OLMainView : CPSplitView
{
    CPView _currentView @accessors(property=currentView, readonly);
	CPView _sourceView @accessors(property=sourceView);
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
    }
    
    return self;
}

- (void)setCurrentView:(CPView)newView
{
	if(_currentView)
	{
    	[self replaceSubview:_currentView with:newView];
	}
    
    _currentView = newView;
}

- (CGRect)currentViewFrame
{
    return [_currentView frame];
}

@end