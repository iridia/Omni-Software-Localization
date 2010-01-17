@import <AppKit/CPView.j>

@implementation OLCreateNewBundleWindow : CPWindow
{
    CPButton            createButton    @accessors;
    CPButton            cancelButton    @accessors;
    CPPopUpButton       popUpButton     @accessors;
}

- (id)initWithContentRect:(CGRect)aRect styleMask:(unsigned)aStyleMask
{
    self = [super initWithContentRect:aRect styleMask:aStyleMask];
    if(self)
    {
        view = [self contentView];
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 25)];
        [popUpButton setCenter:CGPointMake(CGRectGetWidth([view frame])-90, 20)];
        
        createButton = [CPButton buttonWithTitle:@"Create"];
     
        cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        
        [view addSubview:popUpButton positioned:CPViewWidthCentered | CPViewHeightCentered relativeTo:view withPadding:0.0];
        [view addSubview:createButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:view withPadding:10.0];
        [view addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:createButton withPadding:10.0];
    }
    return self;
}

@end
