@import <AppKit/CPWindow.j>

@implementation OLCreateNewBundleWindow : CPWindow
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
        
        [self setTitle:@"Add a Language..."];
        
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
        
        var createButton = [CPButton buttonWithTitle:@"Create Language"];
        [createButton setTarget:self];
        [createButton setAction:@selector(create:)];
     
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(closeSheet:)];
        
        [view addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:view withPadding:0.0];
        [view addSubview:createButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:view withPadding:12.0];
        [view addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:createButton withPadding:12.0];
        
        [cancelButton setDefaultButton:YES];
    }
    return self;
}

- (void)create:(id)sender
{
    var sel = CPSelectorFromString(@"shouldCreateBundleForLanguage:");
    if ([delegate respondsToSelector:sel])
    {
        [delegate performSelector:sel withObject:[popUpButton titleOfSelectedItem]];
    }
    
    [self closeSheet:sender];
}

- (void)reloadData
{
    var sel = CPSelectorFromString(@"availableLanguagesForSelectedProject");
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
