@import <Foundation/CPObject.j>

// Notifications
OLContentViewControllerShouldUpdateContentViewByUserInfo = @"OLContentViewControllerShouldUpdateContentViewByUserInfo";
OLContentViewControllerShouldUpdateContentViewByObject = @"OLContentViewControllerShouldUpdateContentViewByObject";

@implementation OLContentViewController : CPObject
{	
	CPView			currentView;

    @outlet 		CPView			contentView;
}

- (void)awakeFromCib
{
   [[CPNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(updateCurrentViewByUserInfo:)
		name:OLContentViewControllerShouldUpdateContentViewByUserInfo
		object:nil];
		
	[[CPNotificationCenter defaultCenter]
    		addObserver:self
    		selector:@selector(updateCurrentViewByObject:)
    		name:OLContentViewControllerShouldUpdateContentViewByObject
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

- (void)updateCurrentViewByUserInfo:(CPNotificaiton)aNotification
{
    var userInfo = [aNotification userInfo];
    
    if (userInfo)
    {
        view = [userInfo objectForKey:@"view"];
    }

    [self setCurrentView:view];
}

- (void)updateCurrentViewByObject:(CPNotificaiton)aNotification
{
    var view = nil;
    
    var anObject = [aNotification object];
    if ([anObject respondsToSelector:@selector(contentView)])
    {
        view = [anObject contentView];
    }

    [self setCurrentView:view];
}

@end
