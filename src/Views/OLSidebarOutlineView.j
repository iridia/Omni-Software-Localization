@import <AppKit/CPOutlineView.j>

@implementation OLSidebarOutlineView : CPOutlineView
{
}

- (id)initWithFrame:(CGRect)aRect
{
    if (self = [super initWithFrame:aRect])
    {
        [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var onlyColumn = [[CPTableColumn alloc] initWithIdentifier:@"OnlyColumn"];
        [onlyColumn setWidth:CGRectGetWidth(aRect)];
        
        [self addTableColumn:onlyColumn];
        [self setOutlineTableColumn:onlyColumn];
        [self setHeaderView:nil];
        [self setCornerView:nil];     
    }
    return self;
}

/*
- (void)drawRect:(CGRect)aRect
{
    // Add drawing code here
}
*/

/*
- (void)layoutSubviews
{
    // Add layout code here
}
*/

@end
