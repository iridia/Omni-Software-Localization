@import <AppKit/CPCollectionView.j>

@import "OLResourceBundleView.j"
@import "../models/OLApplication.j"


@implementation OLSourceView : CPView
{
	OLResourceBundleView detailView @accessors;
	CPCollectionView applicationsView;
	OLApplication _currentApplication @accessors(property=currentApplication);
	
}

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	
	if (self)
	{
		var applicationListView = [[CPCollectionView alloc] init];
		[applicationListView setView:[[ApplicationListView alloc] initWithFrame:CGRectMakeZero()]];
		
		applicationsView = [[CPCollectionView alloc] initWithFrame:rect];
		[applicationsView setItemPrototype:applicationListView];
		[applicationsView setMaxNumberOfColumns:1];
		[applicationsView setVerticalMargin:0.0];
		[applicationsView setMinItemSize:CGSizeMake(100.0, 40.0)];
		[applicationsView setMaxItemSize:CGSizeMake(1000000.0, 40.0)];
		[applicationsView setDelegate:self];
		[applicationsView setAutoresizingMask:CPViewWidthSizable];
		
		[self addSubview:applicationsView];
		[self setBackgroundColor:[CPColor colorWithCalibratedRed:0.840 green:0.868 blue:0.899 alpha:1.000]];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
	if (keyPath === @"applications") {
		[applicationsView setContent:[object users]];
		[applicationsView reloadContent];
	}
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	var listIndex = [[aCollectionView selectionIndexes] firstIndex];
	
	var applications = [applicationsView content];
	
	var application = [applications objectAtIndex:listIndex];
	
	if (application !== _currentApplication)
	{
		[self setCurrentApplication:application];
	}
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

	[label setStringValue:[anObject displayName]];
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