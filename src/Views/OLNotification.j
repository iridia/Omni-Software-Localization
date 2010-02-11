@import <AppKit/CPWindow.j>
@import "../Categories/CPView+Positioning.j"

@implementation OLNotification : CPWindow
{
    CPTextField     notification;
}

- (id)init
{
    self = [super initWithContentRect:CGRectMake(0, 0, 200, 30) styleMask:CPHUDBackgroundWindowMask | CPClosableWindowMask];
    if(self)
    {
        notification = [CPTextField labelWithTitle:@"adssdaf"];
        [notification setFont:[CPFont boldSystemFontOfSize:14.0]];
        [notification setTextColor:[CPColor whiteColor]];
    }
    return self;
}

- (void)setNotificationText:(CPString)someTextValue
{
    [notification removeFromSuperview];
    [notification setStringValue:someTextValue];
    [notification sizeToFit];
    [[self contentView] addSubview:notification positioned:CPViewTopAligned | CPViewWidthCentered relativeTo:[self contentView] withPadding:0.0];
}

- (void)start
{
    [self orderFront:self];
    [CPTimer scheduledTimerWithTimeInterval:2.0 callback:function(){[self close];} repeats:NO];
}

@end
