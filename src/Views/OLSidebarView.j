@import <AppKit/CPCollectionView.j>

@implementation OLSourceView : CPView
{
	CPCollectionView _applicationsView @accessors;
	id _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	
	if (self)
	{
		var applicationListView = [[CPCollectionViewItem alloc] init];
		[applicationListView setView:[[ApplicationListView alloc] initWithFrame:CGRectMakeZero()]];
		
		_applicationsView = [[CPCollectionView alloc] initWithFrame:rect];
		[_applicationsView setItemPrototype:applicationListView];
		[_applicationsView setMaxNumberOfColumns:1];
		[_applicationsView setVerticalMargin:0.0];
		[_applicationsView setMinItemSize:CGSizeMake(100.0, 40.0)];
		[_applicationsView setMaxItemSize:CGSizeMake(1000000.0, 40.0)];
		[_applicationsView setAutoresizingMask:CPViewWidthSizable];
		
		[self addSubview:_applicationsView];
	}
	
	return self;
}

- (void)setDelegate:(id)aDelegate
{
	_delegate = aDelegate;
	[_applicationsView setContent:[_delegate items]];
	[_applicationsView reloadContent];
}

@end

@implementation ApplicationListView : CPView
{
	CPTextField label;
	CPView highlightView;
}

- (void)setRepresentedObject:(JSObject)anObject
{
	if (!label)
	{
		label = [[CPTextField alloc] initWithFrame:CGRectInset([self bounds], 4, 4)];
		
		[label setFont:[CPFont systemFontOfSize:16.0]];
		[label setTextShadowColor:[CPColor whiteColor]];
		[label setTextShadowOffset:CGSizeMake(0, 1)];
 
		[self addSubview:label];
	}

	[label setStringValue:anObject];
	[label sizeToFit];
 
	[label setFrameOrigin:CGPointMake(10,CGRectGetHeight([label bounds]) / 2.0)];

}
 
- (void)setSelected:(BOOL)flag
{
	if (!highlightView)
	{
		highlightView = [[CPView alloc] initWithFrame:CGRectCreateCopy([self bounds])];
		[highlightView setBackgroundColor:[CPColor colorWithCalibratedRed:0.561 green:0.631 blue:0.761 alpha:1.000]];
		[highlightView setAutoresizingMask:CPViewWidthSizable];
	}
 
	if (flag)
	{
		[self addSubview:highlightView positioned:CPWindowBelow relativeTo:label];
		[label setTextColor:[CPColor whiteColor]];	
		[label setTextShadowColor:[CPColor blackColor]];
	}
	else
	{
		[highlightView removeFromSuperview];
		[label setTextColor:[CPColor blackColor]];
		[label setTextShadowColor:[CPColor whiteColor]];
	}
}

@end