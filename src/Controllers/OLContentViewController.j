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

- (void)updateCurrentView:(CPNotificaiton)aNotification
{
    var userInfo = [aNotification userInfo];
    
    if (userInfo)
    {
        view = [userInfo objectForKey:@"view"];
    }

    [self setCurrentView:view];
}

@end
