@import <AppKit/CPView.j>

@implementation OLNavigationBarView : CPView
{
    CPView      backView        @accessors(readonly);
    CPView      titleView       @accessors(readonly);
    CPView      accessoryView   @accessors(readonly);
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        [self setBackgroundColor:[CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/_CPToolbarViewBackground.png"]]]];
        
        titleView = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.0)];
        [titleView setFont:[CPFont boldSystemFontOfSize:20.0]];
        [titleView setTextShadowColor:[CPColor colorWithCalibratedWhite:240.0 / 255.0 alpha:1.0]];
        [titleView setTextShadowOffset:CGSizeMake(0.0, 1.5)];
        [titleView setTextColor:[CPColor colorWithCalibratedWhite:79.0 / 255.0 alpha:1.0]];
        [titleView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];
        
        [self addSubview:titleView];
    }
    return self;
}

- (void)setTitle:(CPString)aTitle
{
    [titleView setStringValue:aTitle];
    [titleView sizeToFit];
    [self _centerTitleView];
}

- (void)setTitleView:(CPView)aTitleView
{
    if (titleView === aTitleView)
        return;
    
    [titleView removeFromSuperview];
    
    titleView = aTitleView;
    
    [titleView setAutoresizingMask:CPViewMaxXMargin | CPViewMinXMargin];
    [self addSubview:titleView positioned:CPViewWidthCentered | CPViewHeightCentered relativeTo:self withPadding:0.0];
}

- (void)setAccessoryView:(CPView)anAccessoryView
{
    if (accessoryView === anAccessoryView)
        return;
    
    [accessoryView removeFromSuperview];
        
    accessoryView = anAccessoryView;
    
    [accessoryView setAutoresizingMask:CPViewMinXMargin];
    [self addSubview:accessoryView positioned:CPViewRightAligned | CPViewHeightCentered relativeTo:self withPadding:5.0];
}

- (void)setBackView:(CPView)aBackView
{
    if (backView === aBackView)
        return;
        
    [backView removeFromSuperview];
    
    backView = aBackView;
    
    [backView setAutoresizingMask:CPViewMinXMargin];
    [self addSubview:backView positioned:CPViewLeftAligned | CPViewHeightCentered relativeTo:self withPadding:5.0];
}

- (void)_centerTitleView
{
    [titleView setCenter:CPMakePoint(CGRectGetWidth([self bounds]) / 2.0, CGRectGetHeight([self bounds]) / 2.0)];
}

- (void)repositionBackView
{
    [backView removeFromSuperview];
    [self addSubview:backView positioned:CPViewLeftAligned | CPViewHeightCentered relativeTo:self withPadding:5.0];
}

@end
