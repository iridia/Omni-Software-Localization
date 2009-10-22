@import <AppKit/CPSplitView.j>

@implementation OLMainView : CPSplitView
{
    CPView _currentView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setIsPaneSplitter:YES];
        [self setVertical:YES];
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var sourceView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, 200, CGRectGetHeight(frame))];
        [sourceView setBackgroundColor:[CPColor sourceViewColor]];
        [sourceView setAutoresizingMask:CPViewHeightSizable | CPViewMaxXMargin];

        [self addSubview:sourceView];

        _currentView = [[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame) - 200, CGRectGetHeight(frame))];
        [_currentView setBackgroundColor:[CPColor lightGrayColor]];
        [_currentView setAutoresizingMask:CPViewHeightSizable | CPViewWidthSizable];

        [self addSubview:_currentView];
    }
    
    return self;
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