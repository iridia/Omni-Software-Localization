@import <Foundation/CPObject.j>

@import "../Views/OLResourcesView.j"

@implementation OLContentViewController : CPObject
{
	id _contentController @accessors(property=contentController);
	id _transitionManager @accessors(property=transitionManager);
	id _delegate @accessors(property=delegate);
	
	OLResourcesView _resourcesView;
	CPView          _currentView;

    @outlet CPView                      contentView;
    @outlet OLResourceBundleController  resourceBundleController;
}

- (void)awakeFromCib
{
    _resourcesView = [[OLResourcesView alloc] initWithFrame:[contentView bounds]];
    [_resourcesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [_resourcesView setDelegate:resourceBundleController];
    [_resourcesView setResources:[resourceBundleController bundles]];
    [resourceBundleController addObserver:_resourcesView forKeyPath:@"bundles" options:CPKeyValueObservingOptionNew context:nil];
}

- (void)showResourcesView
{
    if (_currentView !== _resourcesView)
    {
        if (_currentView)
        {
            [_currentView removeFromSuperview];
        }
    
        _currentView = _resourcesView;
        [contentView addSubview:_currentView];
    }
}


@end
