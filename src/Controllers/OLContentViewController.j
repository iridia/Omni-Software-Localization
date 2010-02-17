@import <Foundation/CPObject.j>

// Notifications
OLContentViewControllerShouldUpdateContentView = @"OLContentViewControllerShouldUpdateContentView";

@implementation OLContentViewController : CPObject
{	
	CPView			currentView;

    @outlet 		CPView			contentView;
}

- (void)awakeFromCib
{
   [[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(updateCurrentView:)
		name:OLContentViewControllerShouldUpdateContentView
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

@implementation OLContentViewController (Notifications)

- (void)updateCurrentView:(CPNotificaiton)aNotification
{
    var userInfo = [aNotification userInfo];
    var view = nil;
    
    if (userInfo)
    {
        view = [userInfo objectForKey:@"view"];
    }
    
    if (!view)
    {
        var anObject = [aNotification object];
        if ([anObject respondsToSelector:@selector(contentView)])
        {
            view = [anObject contentView];
        }
    }

    [self setCurrentView:view];
}

@end
