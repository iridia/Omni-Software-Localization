@import <Foundation/CPObject.j>

@import "../Views/OLResourcesView.j"

@implementation OLContentViewController : CPObject
{
	id _contentController @accessors(property=contentController);
	id _transitionManager @accessors(property=transitionManager);
	id _delegate @accessors(property=delegate);
	
	OLResourcesView 			_resourcesView;
	CPView          			_currentView;

    @outlet 					CPView						contentView;
}

- (void)awakeFromCib
{
	_resourcesView = [[OLResourcesView alloc] initWithFrame:[contentView bounds]];
    [_resourcesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
}

- (void)setResourceViewDelegate:(id)delegate
{
	[_resourcesView setDelegate:delegate];
    [delegate addObserver:_resourcesView forKeyPath:@"bundles" options:CPKeyValueObservingOptionNew context:nil];
}

- (void)setCurrentView:(CPView)aView
{
	if (_currentView)
    {
        [_currentView removeFromSuperview];
    }

    _currentView = aView;
    [contentView addSubview:_currentView];
}

@end

@implementation OLContentViewController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedProject":
			[self setCurrentView:_resourcesView];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end
