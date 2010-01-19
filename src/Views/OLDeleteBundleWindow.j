@import <AppKit/CPView.j>

@implementation OLDeleteBundleWindow : CPWindow
{
    CPButton            deleteButton    @accessors;
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
        
        deleteButton = [CPButton buttonWithTitle:@"Delete"];
        [deleteButton setAction:@selector(delete:)];
     
        cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setAction:@selector(cancel:)];
        
        [view addSubview:popUpButton positioned:CPViewWidthCentered | CPViewHeightCentered relativeTo:view withPadding:0.0];
        [view addSubview:deleteButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:view withPadding:10.0];
        [view addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:deleteButton withPadding:10.0];
    }
    return self;
}

- (void)setUp:(OLResourceBundleController)resourceBundleController
{
    [deleteButton setTarget:resourceBundleController];
    [cancelButton setTarget:resourceBundleController];
    
    [popUpButton addItemsWithTitles:[resourceBundleController titlesOfLocalizedLanguages]];
}

@end
