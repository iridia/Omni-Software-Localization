@import <AppKit/CPView.j>

@import "OLTableView.j"

OLMailViewFromUserIDColumnHeader = @"OLMailViewFromUserIDColumnHeader";
OLMailViewSubjectColumnHeader = @"OLMailViewSubjectColumnHeader";
OLMailViewDateSentColumnHeader = @"OLMailViewDateSentColumnHeader";

@implementation OLMailView : CPView
{
	CPSplitView     splitView;
	OLTableView     messagesView;
	CPView          contentView;
	CPTextField     textView;
}

- (id)initWithFrame:(CGRect)aFrame
{
	if (self = [super initWithFrame:aFrame])
	{    
        splitView = [[CPSplitView alloc] initWithFrame:aFrame];
        [splitView setVertical:NO];
        [splitView setDelegate:self];
        [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var fromColumn = [[CPTableColumn alloc] initWithIdentifier:OLMailViewFromUserIDColumnHeader];
        [[fromColumn headerView] setStringValue:@"From"];
        [fromColumn setWidth:100.0];

        var subjectColumn = [[CPTableColumn alloc] initWithIdentifier:OLMailViewSubjectColumnHeader];
        [[subjectColumn headerView] setStringValue:@"Subject"];
        [subjectColumn setWidth:200.0];

        var dateColumn = [[CPTableColumn alloc] initWithIdentifier:OLMailViewDateSentColumnHeader];
        [[dateColumn headerView] setStringValue:@"Date Sent"];
        [dateColumn setWidth:(CGRectGetWidth(aFrame) - 300.0)];

        messagesView = [[OLTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) / 2.0)
                            columns:[fromColumn, subjectColumn, dateColumn]];
        [messagesView setUsesAlternatingRowBackgroundColors:NO];
        [messagesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        [splitView addSubview:messagesView];

        contentView = [[CPView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) / 2.0)];
        [contentView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        var contentViewScrollView = [[CPScrollView alloc] initWithFrame:[contentView bounds]];
        [contentViewScrollView setAutohidesScrollers:YES];
        [contentViewScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];

        textView = [[CPTextField alloc] initWithFrame:[contentView bounds]];
		[textView setLineBreakMode:CPLineBreakByWordWrapping];
        [textView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
        [contentViewScrollView setDocumentView:textView];
        [contentView addSubview:contentViewScrollView];
        [splitView addSubview:contentView];
        
        [self addSubview:splitView];
	}
	return self;
}

- (void)setDelegate:(id)aDelegate
{
    [messagesView setDelegate:aDelegate];
}

- (void)setDataSource:(id)aDataSource
{
    [messagesView setDataSource:aDataSource];
}

- (void)reloadData
{
    [messagesView reloadData];
    [textView setContent:@""];
}

- (void)setContent:(CPString)content
{
    [textView setStringValue:content];
}

@end

@implementation OLMailView (CPSplitViewDelegate)

- (BOOL)splitView:(CPSplitView)splitView canCollapseSubview:(CPView)subview
{
    return (subview !== messagesView);
}

- (BOOL)splitView:(CPSplitView)splitView shouldCollapseSubview:(CPView)subview forDoubleClickOnDividerAtIndex:(int)index
{
    return (subview !== messagesView);
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{
    return proposedMin + 150.0;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{    
    return proposedMax - 150.0;
}

@end
