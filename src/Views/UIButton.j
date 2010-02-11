@import <AppKit/CPButton.j>

@implementation UIButton : CPButton

- (void)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var bezelColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
            [
                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/ui-button-bezel-left.png" size:CGSizeMake(15, 24)],
                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/ui-button-bezel-center.png" size:CGSizeMake(1, 24)],
                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/ui-button-bezel-highlighted-right.png" size:CGSizeMake(4, 24)]
            ]
        isVertical:NO]];
        
        var bezelHighlightColor = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
            [
                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/ui-button-bezel-highlighted-left.png" size:CGSizeMake(15, 24)],
                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/ui-button-bezel-highlighted-center.png" size:CGSizeMake(1, 24)],
                [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/ui-button-bezel-right.png" size:CGSizeMake(4, 24)]
            ]
        isVertical:NO]];
        
        [self setValue:bezelColor forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered];
        [self setValue:bezelHighlightColor forThemeAttribute:@"bezel-color" inState:CPThemeStateBordered|CPThemeStateHighlighted];
        [self setValue:CGInsetMake(0.0, 5.0, 0.0, 10.0) forThemeAttribute:@"content-inset"]
    }
    return self;
}


@end
