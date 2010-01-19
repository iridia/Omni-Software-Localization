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
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		var splitViewSize = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    
        mailView = [[OLMessageSplitView alloc] initWithFrame:splitViewSize];
        [self addSubview:mailView];
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
