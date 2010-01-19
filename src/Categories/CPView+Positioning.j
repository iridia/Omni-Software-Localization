CPViewBelow             = 1;
CPViewWidthCentered     = 2;
CPViewHeightCentered    = 4;
CPViewRightAligned      = 8;
CPViewBottomAligned     = 16;
CPViewHeightSame        = 32;
CPViewOnTheLeft         = 64;
CPViewLeftAligned       = 128;
CPViewTopAligned        = 256;
CPViewOnTheRight        = 512;

@implementation CPView (Positioning)

- (void)addSubview:(CPView)aView positioned:(unsigned)positioning relativeTo:(CPView)anotherView withPadding:(int)padding
{
    padding = padding || 0;
    
    var yPos = [aView frame].origin.y;
    var xPos = [aView frame].origin.x;
    
    // yPositioning
    if (positioning & CPViewBelow)
    {
        yPos = CGRectGetHeight([anotherView bounds]) + [anotherView frame].origin.y + padding;
    }
    
    if (positioning & CPViewHeightCentered)
    {
        yPos = (CGRectGetHeight([anotherView bounds]) / 2.0) - (CGRectGetHeight([aView bounds]) / 2.0);
    }
    
    if (positioning & CPViewBottomAligned)
    {
        yPos = CGRectGetHeight([anotherView bounds]) - CGRectGetHeight([aView bounds]) - padding;
    }
    
    if (positioning & CPViewTopAligned)
    {
        yPos = 0.0 + padding;
    }
    
    if (positioning & CPViewHeightSame)
    {
        yPos = [anotherView frame].origin.y;
    }
    
    // xPositioning
    if (positioning & CPViewWidthCentered)
    {
        xPos = (CGRectGetWidth([self bounds]) / 2.0) - (CGRectGetWidth([aView bounds]) / 2.0);
    }
    
    if (positioning & CPViewRightAligned)
    {
        xPos = CGRectGetWidth([anotherView frame]) - CGRectGetWidth([aView bounds]) - padding;
    }
    
    if (positioning & CPViewLeftAligned)
    {
        xPos = 0.0 + padding;
    }
    
    if (positioning & CPViewOnTheLeft)
    {
        xPos = [anotherView frame].origin.x - CGRectGetWidth([aView bounds]) - padding;
    }
    
    if (positioning & CPViewOnTheRight)
    {
        xPos = [anotherView frame].origin.x + [anotherView frame].size.width + padding;
    }
    
    [aView setFrameOrigin:CPMakePoint(xPos, yPos)];
    [self addSubview:aView];
}

- (void)setWidth:(CGFloat)width
{
    [self setFrameSize:CGSizeMake(width, CGRectGetHeight([self bounds]))];
}

- (void)centerHorizontally
{
    [self setCenter:CPMakePoint([[self superview] bounds].size.width / 2.0, [self bounds].size.height / 2.0)];
}

@end