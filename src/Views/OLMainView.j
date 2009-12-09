@import <AppKit/CPSplitView.j>

@implementation OLMainView : CPSplitView
{
    CPView _currentView;
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

        _sourceView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, CGRectGetHeight(frame))];
        [self addSubview:_sourceView];

        _currentView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
        [self addSubview:_currentView];
    }
    
    return self;
}	

- (void)setSourceView:(CPView)newView
{
	[self replaceSubview:_sourceView with:newView];
	
	_sourceView = newView;
}

- (void)setCurrentView:(CPView)newView
{    
    [self replaceSubview:_currentView with:newView];
    
    _currentView = newView;
}

@end