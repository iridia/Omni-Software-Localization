@import <Foundation/CPObject.j>

@import "../Views/OLResourcesView.j"

@implementation OLContentViewController : CPObject
{	
	CPView			currentView;
	CPView			resourcesView   @accessors;
	CPView			glossariesView	@accessors;
	CPView          mailView        @accessors;

    @outlet 		CPView			contentView;
}

- (void)setCurrentView:(CPView)aView
{
    if (currentView !== aView)
    {
    	if (currentView)
        {
            [currentView removeFromSuperview];
        }

        currentView = aView;
        [currentView setFrame:[contentView bounds]];
        [contentView addSubview:currentView];
    }
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
		case @"selectedCommunityItem":
		    var selectedCommunityItem = [object selectedCommunityItem];
		    if(selectedCommunityItem)
		    {
		        [self setCurrentView:mailView];
		    }
		    break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end
