@import <AppKit/CPCollectionView.j>

@import "OLResourceBundleView.j"
@import "OLResourcesView.j"
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
		
		//This is how it was for CPCollectionView, being changed for CPOutlineView.
		var applicationListView = [[CPCollectionViewItem alloc] init];
		[applicationListView setView:[[ApplicationListView alloc] initWithFrame:CGRectMakeZero()]];
		
		applicationsView = [[CPCollectionView alloc] initWithFrame:rect];
		[applicationsView setItemPrototype:applicationListView];
		[applicationsView setMaxNumberOfColumns:1];
		[applicationsView setVerticalMargin:0.0];
		[applicationsView setMinItemSize:CGSizeMake(100.0, 40.0)];
		[applicationsView setMaxItemSize:CGSizeMake(1000000.0, 40.0)];		
		[applicationsView setDelegate:self];
		[applicationsView setAutoresizingMask:CPViewWidthSizable];
		[applicationsView setContent:new Array("Resources","Resource Bundles","Others")];
		[applicationsView reloadContent];
		
		[self addSubview:applicationsView];		
	}
	
	return self;
}
/*
// These are the required DataSource methods
-(void)outlineView:(CPOutlineView)anOutlineView child:(CPNumber)aChild ofItem:(id)anItem
{
	console.log("child of item");
	return @"aString";
	//return [[CPView alloc] initWithFrame:CGRectMake(0,0,100,100)];
}

-(void)outlineView:(CPOutlineView)anOutlineView isItemExpandable:(BOOL)flag
{
	console.log("isItemExpandable");
	return YES;
}

-(void)outlineView:(CPOutlineView)anOutlineView numberOfChildrenOfItem:(CPNumber)aNumber
{
	console.log("number of children of item");
	return 4;
}
-(void)outlineView:(CPOutlineView)anOutlineView objectValueForTableColumn:(id)aTableColumn byItem:(id)anItem
{
	console.log("object value for table column");
	return @"aString";
}
//End required methods.
*/
- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	var listIndex = [[aCollectionView selectionIndexes] firstIndex];
	    
    var apps = [applicationsView content];
    
    var app = [apps objectAtIndex:listIndex];
    
    if (app !== _currentApplication)
    {
        [self setCurrentApplication:app];
		if (app == "Resources")
		{
			var resourceView = [[OLResourcesView alloc] initWithFrame:[[self superview] currentViewFrame]];
			[resourceView setAutoresizingMask:CPViewHeightSizable | CPViewMaxXMargin];
			
			//TODO:  get the file names and display in the view.
			//[resourceView setContents:[OLResourceBundleController getAllResources]];
			[[self superview] setCurrentView:resourceView];
			console.log("Made it.");
			
		}
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