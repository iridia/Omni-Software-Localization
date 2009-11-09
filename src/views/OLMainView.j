@import <AppKit/CPSplitView.j>

@implementation OLMainView : CPSplitView
{
    CPView _currentView @accessors(property=currentView, readonly);
	CPView _sourceView @accessors(property=sourceView, readonly);
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

		_sourceView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
        [self addSubview:_sourceView];

        _currentView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
        [self addSubview:_currentView];
    }
    
    return self;
}

- (void)setCurrentView:(CPView)newView
{
    [self replaceSubview:_currentView with:newView];
    
    _currentView = newView;
}

- (void)setSourceView:(CPView)newView
{
	[self replaceSubview:_sourceView with:newView];
	
	_sourceView = newView;
}

- (CGRect)currentViewFrame
{
    return [_currentView frame];
}

@end