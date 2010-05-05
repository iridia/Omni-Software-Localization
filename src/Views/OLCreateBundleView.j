@import <AppKit/CPView.j>

@implementation OLCreateBundleView : CPView
{
    CPPopUpButton   popUpButton;
    id              delegate        @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
        [self addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:self withPadding:0.0];

        var createButton = [CPButton buttonWithTitle:@"Create Language"];
        [createButton setTarget:self];
        [createButton setAction:@selector(create:)];
        [self addSubview:createButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:self withPadding:12.0];

        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(endWindowAsSheet:)];
        [cancelButton setDefaultButton:YES];
        [self addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:self withPadding:12.0];
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
}

// This is an expensive operation. Be careful.
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
