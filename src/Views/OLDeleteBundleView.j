@import <AppKit/CPView.j>

@implementation OLDeleteBundleView : CPView
{
    id              delegate        @accessors;
    CPPopUpButton   popUpButton;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {        
        popUpButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
        [self addSubview:popUpButton positioned:CPViewWidthCentered relativeTo:self withPadding:0.0];
        
        var deleteButton = [CPButton buttonWithTitle:@"Delete Langugage"];
        [deleteButton setTarget:self];
        [deleteButton setAction:@selector(delete:)];
        [self addSubview:deleteButton positioned:CPViewBottomAligned | CPViewRightAligned relativeTo:self withPadding:12.0];
     
        var cancelButton = [CPButton buttonWithTitle:@"Cancel"];
        [cancelButton setTarget:self];
        [cancelButton setAction:@selector(endWindowAsSheet:)];
        [cancelButton setDefaultButton:YES];
        [self addSubview:cancelButton positioned:CPViewOnTheLeft | CPViewHeightSame relativeTo:self withPadding:12.0];
    }
    return self;
}

- (void)delete:(id)sender
{
    var sel = CPSelectorFromString(@"shouldDeleteBundleForLanguage:");
    if ([delegate respondsToSelector:sel])
    {
        [delegate performSelector:sel withObject:[popUpButton indexOfSelectedItem]];
    }
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

@end
