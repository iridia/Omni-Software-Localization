@import "../Models/OLMessage.j"

@implementation OLMessageDetailView : CPView
{
    CPScrollView    scrollView;
    CPTextField     content         @accessors;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {     
        scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) -  32.0)];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		[scrollView setDocumentView:content];
		[self addSubview:scrollView];
    }
    
    return self;
}

@end