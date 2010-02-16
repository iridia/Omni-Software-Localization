@import <AppKit/CPWindow.j>

@implementation OLDeleteBundleWindow : CPWindow
{
    CPPopUpButton   popUpButton;
    id              delegate        @accessors;
}

- (id)initWithContentRect:(CGRect)aRect styleMask:(unsigned)aStyleMask
{
    self = [super initWithContentRect:aRect styleMask:aStyleMask];
    if(self)
    {
        var view = [self contentView];
        
        [self setTitle:@"Delete a Language..."];
        
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
        
        var deleteButton = [CPButton buttonWithTitle:@"Delete Langugage"];
        [deleteButton setTarget:self];
        [deleteButton setAction:@selector(delete:)];
     
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(closeSheet:)];
        [cancelButton setTag:CPCancelButton];
        
        [view addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:view withPadding:0.0];
        [view addSubview:deleteButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:view withPadding:12.0];
        [view addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:deleteButton withPadding:12.0];
        
        [cancelButton setDefaultButton:YES];
    }
    return self;
}

- (void)delete:(id)sender
{
    var sel = CPSelectorFromString(@"shouldDeleteBundleForLanguage:");
    if ([delegate respondsToSelector:sel])
    {
        [delegate performSelector:sel withObject:[popUpButton titleOfSelectedItem]];
    }
    
    [self closeSheet:sender];
}

- (void)reloadData
{
    var sel = CPSelectorFromString(@"languagesForSelectedProject");
    if ([delegate respondsToSelector:sel])
    {
        var languages = [delegate performSelector:sel withObject:nil];
        [popUpButton removeAllItems];
        [popUpButton addItemsWithTitles:languages];
    }
}

- (void)closeSheet:(id)sender
{
    [CPApp endSheet:self];
}

@end
