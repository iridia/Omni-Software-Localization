@import <Foundation/CPObject.j>

@implementation OLCreateBundleWindowController : CPObject
{
    CPWindow        _window         @accessors(property=window);
    CPPopUpButton   popUpButton;
    id              delegate        @accessors;
}

- (id)init
{
    if (self = [super init])
    {
        var aWindow = [[CPWindow alloc] initWithContentRect:CGRectMake(0.0, 0.0, 200.0, 100.0) styleMask:CPDocModalWindowMask];
        [aWindow setTitle:@"Add a Language..."];
        [aWindow setDelegate:self];

        var contentView = [aWindow contentView];

        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];

        var createButton = [CPButton buttonWithTitle:@"Create Language"];
        [createButton setTarget:self];
        [createButton setAction:@selector(create:)];

        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(endWindowAsSheet:)];
        [cancelButton setDefaultButton:YES];
        [contentView addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:contentView withPadding:0.0];
        [contentView addSubview:createButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:contentView withPadding:12.0];
        [contentView addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:createButton withPadding:12.0];
        
        _window = aWindow;
    }
    return self;
}

- (void)showWindowAsSheet:(id)sender
{
    [CPApp beginSheet:[self window]
        modalForWindow:[[CPApp delegate] theWindow]
        modalDelegate:[self delegate]
        didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
        contextInfo:nil];
}

- (void)endWindowAsSheet:(id)sender
{
    [CPApp endSheet:[self window]];
}

- (void)create:(id)sender
{
    var sel = CPSelectorFromString(@"shouldCreateBundleForLanguage:");
    if ([delegate respondsToSelector:sel])
    {
        [delegate performSelector:sel withObject:[popUpButton titleOfSelectedItem]];
    }
    
    [self endWindowAsSheet:self];
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

@end
