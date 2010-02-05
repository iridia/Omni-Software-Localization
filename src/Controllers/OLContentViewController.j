@import <Foundation/CPObject.j>

@implementation OLContentViewController : CPObject
{	
	CPView			currentView;

    @outlet 		CPView			contentView;
}

- (void)awakeFromCib
{
    [[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(outlineViewSelectionDidChangeNotification:)
		name:CPOutlineViewSelectionDidChangeNotification
		object:nil];
		
   [[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(outlineSelectionDidChangeThroughProfile:)
		name:CPOutlineViewSelectionDidChangeThroughProfileNotification
		object:nil];
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
        
        if (currentView)
        {
            [currentView setFrame:[contentView bounds]];
            [contentView addSubview:currentView];
        }
    }
}

@end

@implementation OLContentViewController (OutlineViewNotification)

- (void)outlineSelectionDidChangeThroughProfile:(CPNotificaiton)aNotification
{   
    [self setCurrentView:[aNotification object]];
}

- (void)outlineViewSelectionDidChangeNotification:(CPNotification)notification
{
    var outlineView = [notification object];

	var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
	var item = [outlineView itemAtRow:selectedRow];
    var parent = [outlineView parentForItem:item];

	if ([parent respondsToSelector:@selector(contentView)])
	{
	    [self setCurrentView:[parent contentView]];
	}
	else
	{
	    [self setCurrentView:nil];
	}
}

@end
