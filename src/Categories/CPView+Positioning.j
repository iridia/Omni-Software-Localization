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
CPViewLeftSame          = 1024;
CPViewAbove             = 2048;
CPViewRightSame         = 4096;

@implementation CPView (Positioning)

- (void)addSubview:(CPView)aView positioned:(unsigned)positioning relativeTo:(CPView)anotherView withPadding:(int)padding
{
    padding = padding || 0;
    
    yPos = [self addSubview:aView positioned:positioning relativeTo:anotherView withPaddinginY:padding];
    xPos = [self addSubview:aView positioned:positioning relativeTo:anotherView withPaddinginX:padding];

    [aView setFrameOrigin:CPMakePoint(xPos, yPos)];
    [self addSubview:aView];
}

- (int)addSubview:(CPView)aView positioned:(unsigned)positioning relativeTo:(CPView)anotherView withPaddinginY:(int)padding
{
    var yPos = CGRectGetMinX([aView frame]);
    
    // yPositioning
    if (positioning & CPViewBelow)
    {
        yPos = CGRectGetMaxY([anotherView frame]) + padding;
    }
    
    if (positioning & CPViewAbove)
    {
        yPos = CGRectGetMinY([anotherView frame]) - CGRectGetHeight([aView bounds]) - padding;
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
        yPos = CGRectGetMinY([anotherView frame]);
    }
    return yPos;
}

- (int)addSubview:(CPView)aView positioned:(unsigned)positioning relativeTo:(CPView)anotherView withPaddinginX:(int)padding
{
    var xPos = CGRectGetMinY([aView frame]);
    
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
        xPos = CGRectGetMinX([anotherView frame]) - CGRectGetWidth([aView bounds]) - padding;
    }
    
    if (positioning & CPViewOnTheRight)
    {
        xPos = CGRectGetMaxX([anotherView frame]) + padding;
    }
    
    if (positioning & CPViewLeftSame)
    {
        xPos = CGRectGetMinX([anotherView frame]);
    }

    if (positioning & CPViewRightSame)
    {
        xPos = CGRectGetMaxX([anotherView frame]) - CGRectGetWidth([aView bounds]);
    }
    return xPos;
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