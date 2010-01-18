@import <AppKit/CPView.j>

@import "../Controllers/OLMessageController.j"
@import "OLMessageSplitView.j"

var OLMailViewFromUserIDColumnHeader = @"OLMailViewFromUserIDColumnHeader";
var OLMailViewSubjectColumnHeader = @"OLMailViewSubjectColumnHeader";
var OLMailViewDateSentColumnHeader = @"OLMailViewDateSentColumnHeader";

@implementation OLMailView : CPView
{
	OLMailView		mailView            @accessors;
	CPTextField     title;
	// CPTextField     contentTextField    @accessors;
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		var splitViewSize = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-99);
    
        mailView = [[OLMessageSplitView alloc] initWithFrame:splitViewSize];
        [self addSubview:mailView];
        
        // [self setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        // 
        // var scrollView = [[CPScrollView alloc] initWithFrame:frame];//change to the top half of the splitview
        // [scrollView setAutohidesScrollers:YES];
        // [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        // 
        // tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
        // [tableView setUsesAlternatingRowBackgroundColors:NO];
        // [tableView setAutoresizingMask:CPViewWidthSizable | CPViewWidthSizable];
        //  
        // // define the header color
        // var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
        // [[tableView cornerView] setBackgroundColor:headerColor];
        // 
        // // add the columns for the message data
        // var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewFromUserIDColumnHeader];
        // [[column headerView] setStringValue:@"From"];
        // [[column headerView] setBackgroundColor:headerColor];
        // [column setWidth:200.0];
        // [tableView addTableColumn:column];
        // 
        // var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewSubjectColumnHeader];
        // [[column headerView] setStringValue:@"Subject"];
        // [[column headerView] setBackgroundColor:headerColor];
        // [column setWidth:300.0];
        // [tableView addTableColumn:column];
        // 
        // var column = [[CPTableColumn alloc] initWithIdentifier:OLMailViewDateSentColumnHeader];
        // [[column headerView] setStringValue:@"Date Sent"];
        // [[column headerView] setBackgroundColor:headerColor];
        // [column setWidth:CGRectGetWidth(frame)-500.0];
        // [tableView addTableColumn:column];
        
        // var contentTextField = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(frame), CGRectGetHeight(frame) / 2.0)];
        // [self addSubview:contentTextField];
        
        // [scrollView setDocumentView:mailView];
        // [self addSubview:scrollView];
	}
	return self;
}

- (void)setCommunityController:(OLCommunityController)communityController
{
    [mailView setCommunityController:communityController];
}

- (void)setMessageController:(OLMessageController)aMessageController
{
    [mailView setMessageController:aMessageController];
}

@end
