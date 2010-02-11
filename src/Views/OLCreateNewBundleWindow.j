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
        [self setTitle:@"Add a Language..."];
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
        [popUpButton setCenter:CGPointMake(CGRectGetWidth([view frame])-90, 20)];
        
        createButton = [CPButton buttonWithTitle:@"Create"];
        [createButton setAction:@selector(create:)];
     
        cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setAction:@selector(cancel:)];
        
        [popUpButton setCenter:CGPointMake(0, 35)];
        
        [view addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:view withPadding:0.0];
        [view addSubview:createButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:view withPadding:12.0];
        [view addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:createButton withPadding:12.0];
    }
    return self;
}

- (void)setUp:(OLResourceBundleController)resourceBundleController
{
    [createButton setTarget:resourceBundleController];
    [cancelButton setTarget:resourceBundleController];
 
    [popUpButton removeAllItems];
    [popUpButton addItemsWithTitles:[resourceBundleController titlesOfAvailableLanguage]];
}

- (void)displaySheet:(id)sender
{
    [CPApp beginSheet:self modalForWindow:[CPApp mainWindow] modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

- (void)closeSheet:(id)sender
{
    [CPApp endSheet:self returnCode:[sender tag]];
}

- (void)didEndSheet:(CPWindow)sheet returnCode:(int)returnCode contextInfo:(id)contextInfo
{
    [sheet orderOut:self];
}

@end
