@import <AppKit/CPView.j>
@import <AppKit/CPAccordionView.j>

@implementation OLProjectDashboardView : CPView
{
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if(self)
    {
        var tabs = [[CPTabView alloc] initWithFrame:CGRectInset(aFrame, 50, 50)];
        [tabs setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        var summaryTab = [[CPTabViewItem alloc] initWithIdentifier:@"summary"];
        [summaryTab setLabel:@"Summary"];
        [summaryTab setView:[[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([tabs bounds]), 300)]];
        
        var branchesTab = [[CPTabViewItem alloc] initWithIdentifier:@"branches"];
        [branchesTab setLabel:@"Branches"];
        [branchesTab setView:[[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([tabs bounds]), 300)]];
        
        var commentsTab = [[CPTabViewItem alloc] initWithIdentifier:@"comments"];
        [commentsTab setLabel:@"Comments"];
        [commentsTab setView:[[CPView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([tabs bounds]), 300)]];
        
        [tabs addTabViewItem:summaryTab];
        [tabs addTabViewItem:branchesTab];
        [tabs addTabViewItem:commentsTab];
        
        [self addSubview:tabs];
    }
    return self;
}

@end
