@import <AppKit/CPView.j>

@implementation OLView : CPView
{
	CPObject	_controller;
}

- (id)initWithFrame:(CGRect)frame withController:(CPObject)controller
{
	if(self = [super initWithFrame:frame])
	{
		_controller = controller;
	}
	return self;
}

- (void)addViews:(CPArray)views
{
	for(var i = 0; i < [views count]; i++)
	{
		[self addSubview:views[i]];
	}
}

@end
