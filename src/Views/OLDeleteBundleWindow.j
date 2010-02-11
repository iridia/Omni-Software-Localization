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
        [self setTitle:@"Delete a Language..."];
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
        
        deleteButton = [CPButton buttonWithTitle:@"Delete Langugage"];
        [deleteButton setAction:@selector(delete:)];
     
        cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setAction:@selector(cancel:)];
        
        [popUpButton setCenter:CGPointMake(0, 35)];
        
        [view addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:view withPadding:0.0];
        [view addSubview:deleteButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:view withPadding:12.0];
        [view addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:deleteButton withPadding:12.0];
        
        [cancelButton setDefaultButton:YES];
    }
    return self;
}

- (void)setUp:(OLResourceBundleController)resourceBundleController
{
    [deleteButton setTarget:resourceBundleController];
    [cancelButton setTarget:resourceBundleController];
    
    [popUpButton removeAllItems];
    [popUpButton addItemsWithTitles:[resourceBundleController titlesOfLocalizedLanguages]];
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
