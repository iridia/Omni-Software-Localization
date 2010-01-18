@import <AppKit/CPSplitView.j>

@import "OLMailView.j"
@import "OLMessageDetailView.j"

var OLMailViewFromUserIDColumnHeader = @"OLMailViewFromUserIDColumnHeader";
var OLMailViewSubjectColumnHeader = @"OLMailViewSubjectColumnHeader";
var OLMailViewDateSentColumnHeader = @"OLMailViewDateSentColumnHeader";

@implementation OLMessageSplitView : CPSplitView
{
    CPTableView             messageTableView    @accessors;
    OLMessageDetailView     messageDetailView   @accessors;
    BOOL                    isEditing;
}

- (id)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if (self)
	{
	    [self setVertical:NO];
	    [self setDelegate:self];
	    
        var scrollView = [[CPScrollView alloc] initWithFrame:aFrame];
        [scrollView setAutohidesScrollers:YES];
        [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        
		// create the resourceTableView
		messageTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
		[messageTableView setUsesAlternatingRowBackgroundColors:NO];
		[messageTableView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
		
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		
		// add the columns for the message data
        var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewFromUserIDColumnHeader];
        [[column headerView] setStringValue:@"From"];
        [[column headerView] setBackgroundColor:headerColor];
        [column setWidth:200.0];
        [messageTableView addTableColumn:column];
        
        var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewSubjectColumnHeader];
        [[column headerView] setStringValue:@"Subject"];
        [[column headerView] setBackgroundColor:headerColor];
        [column setWidth:300.0];
        [messageTableView addTableColumn:column];
        
        var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewDateSentColumnHeader];
        [[column headerView] setStringValue:@"Date Sent"];
        [[column headerView] setBackgroundColor:headerColor];
        [column setWidth:CGRectGetWidth(aFrame)-500.0];
        [messageTableView addTableColumn:column];
        
		
		[[messageTableView cornerView] setBackgroundColor:headerColor];
		
		[scrollView setDocumentView:messageTableView];
		
		[self addSubview:scrollView];

        // Create the editingView up front, show it when needed
		messageDetailView = [[OLMessageDetailView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) / 2.0)];
		[messageDetailView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [self addSubview:messageDetailView];
        [self setPosition:[self maxPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];
	}

	return self;
}

- (void)setCommunityController:(OLCommunityController)aCommunityController
{
    [messageTableView setDataSource:aCommunityController];
    [messageTableView setDelegate:aCommunityController];
}

- (void)setMessageController:(OLMessageController)aMessageController
{
    [messageDetailView setDataSource:aMessageController];
    [messageDetailView setDelegate:aMessageController];
    [messageDetailView setTarget:aMessageController];
}

- (void)showMessageDetailView
{
    if (!isEditing)
    {
        isEditing = YES;
        [self setPosition:([self maxPossiblePositionOfDividerAtIndex:0] - 150.0) ofDividerAtIndex:0];
    }
}

- (void)hideMessageDetailView
{
    isEditing = NO;
    [self setPosition:[self maxPossiblePositionOfDividerAtIndex:0] ofDividerAtIndex:0];
}

@end

@implementation OLMessageSplitView (CPSplitViewDelegate)

- (BOOL)splitView:(CPSplitView)splitView canCollapseSubview:(CPView)subview
{
    return isEditing;
}

- (BOOL)splitView:(CPSplitView)splitView shouldCollapseSubview:(CPView)subview forDoubleClickOnDividerAtIndex:(int)index
{
    return isEditing;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(int)dividerIndex
{
    if (!isEditing)
    {
        return [self maxPossiblePositionOfDividerAtIndex:dividerIndex];
    }
    return proposedMin + 150.0;
}

- (CGFloat)splitView:(CPSplitView)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(int)dividerIndex
{
    if (!isEditing)
    {
        return proposedMax;
    }
    
    return proposedMax - 150.0;
}

@end