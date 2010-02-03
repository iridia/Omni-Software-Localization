@import <AppKit/CPView.j>
@import <AppKit/CPAccordionView.j>

@implementation OLProjectDashboardView : CPView
{
    CPTextField     name;
    CPTextField     subscribers;
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
        
        var summaryView = [[CPView alloc] initWithFrame:CGRectMakeZero()];
        [summaryView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var nameLabel = [CPTextField labelWithTitle:@"Name:"];
        var subscribersLabel = [CPTextField labelWithTitle:@"Subscribers:"];
        
        name = [CPTextField labelWithTitle:@"asdf"];
        subscribers = [CPTextField labelWithTitle:@"fdsa"];
        
        [summaryView addSubview:nameLabel positioned:CPViewLeftAligned | CPViewTopAligned relativeTo:summaryView withPadding:50.0];
        [summaryView addSubview:subscribersLabel positioned:CPViewBelow | CPViewLeftSame relativeTo:nameLabel withPadding:10.0];
        
        [summaryView addSubview:subscribers positioned:CPViewOnTheRight | CPViewHeightSame relativeTo:subscribersLabel withPadding:5.0];
        [summaryView addSubview:name positioned:CPViewAbove | CPViewLeftSame relativeTo:subscribers withPadding:10.0];
        
        [summaryTab setView:summaryView];
        
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
