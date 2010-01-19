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
        content = [[CPTextField alloc] initWithFrame:aFrame];
        
        scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
		[scrollView setAutohidesScrollers:YES];
		[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		[scrollView setDocumentView:content];
		[self addSubview:scrollView];
    }
    
    return self;
}

@end