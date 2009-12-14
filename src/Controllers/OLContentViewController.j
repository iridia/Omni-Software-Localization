@import <Foundation/CPObject.j>

@import "../Views/OLResourcesView.j"

@implementation OLContentViewController : CPObject
{	
	CPView			_currentView;
	CPView			resourcesView   @accessors;
	CPView			glossariesView	@accessors;

    @outlet 		CPView			contentView;
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
            var selectedProject = [object selectedProject];
            if (selectedProject)
            {
    			[self setCurrentView:resourcesView];
    		}
            break;
		case @"selectedGlossary":
		    var selectedGlossary = [object selectedGlossary];
		    if (selectedGlossary)
		    {
		       [self setCurrentView:glossariesView];
		    }
			break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end
