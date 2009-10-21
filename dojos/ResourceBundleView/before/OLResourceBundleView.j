@import "OLView.j"

/*!
 * The view for displaying relevant resource bundle information.
 */
@implementation OLResourceBundleView : OLView

- (id)initWithFrame:(CGRect)frame withController:(CPObject)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{
		var resourceBundle = [controller bundle];
		var title = [CPTextField labelWithTitle:"Resource Bundle in " + [[resourceBundle language] name]];
		
		[title setFont:[CPFont boldFontWithName:"Tahoma" size:24]];
		[title setBezeled:YES];
		[title sizeToFit];
		[title setCenter:CGPointMake([self center].x, 50)];
		[title setBackgroundColor:[CPColor whiteColor]];
		
		[self addSubview:title];
		
		///
		
        var dataView = [[CPCollectionViewItem alloc] init];
        [dataView setView:[[OLResourceView alloc] initWithFrame:CGRectMakeZero()]];
        
        var listOfResources = [[CPCollectionView alloc] initWithFrame:CGRectMake(50, 100, CGRectGetWidth(frame)-100, 500)];
        [listOfResources setItemPrototype:dataView];
        [listOfResources setVerticalMargin:0.0];
        [listOfResources setMinItemSize:CGSizeMake(500.0, 42.0)];
        [listOfResources setMaxItemSize:CGSizeMake(10000.0, 42.0)];
        [listOfResources setDelegate:self];
        
		var arrayOfDataViews = [[CPArray alloc] init];
		
		for(var i = 0; i < [[resourceBundle resources] count]; i++)
		{
			var tempView = [[CPView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame)-100, 42)];
        	var dataView = [CPTextField labelWithTitle:[[[resourceBundle resources] objectAtIndex:i] fileName]];
        	[dataView setCenter:CGPointMake([tempView center].x, 21)];
			[tempView addSubview:dataView];
			[arrayOfDataViews addObject:tempView];
		}

		[listOfResources setContent:arrayOfDataViews];
		[listOfResources reloadContent];
		
		[self addSubview:listOfResources];
	}
	return self;
}

- (void)setupLineItemsWithIndex:(int)index
{
	var resource = [[[[self controller] bundle] resources] objectAtIndex:index];
	
	var lineItems = [resource lineItems];
	var frame = [self bounds];
		
    var dataView = [[CPCollectionViewItem alloc] init];
    [dataView setView:[[OLLineItemView alloc] initWithFrame:CGRectMakeZero()]];
    
    var listOfResources = [[CPCollectionView alloc] initWithFrame:CGRectMake(50, 300, CGRectGetWidth(frame)-100, 200)];
    [listOfResources setItemPrototype:dataView];
    [listOfResources setVerticalMargin:0.0];
    [listOfResources setMinItemSize:CGSizeMake(500.0, 42.0)];
    [listOfResources setMaxItemSize:CGSizeMake(10000.0, 42.0)];
    [listOfResources setDelegate:self];
    
	var arrayOfDataViews = [[CPArray alloc] init];
	
	for(var i = 0; i < [lineItems count]; i++)
	{
		var tempView = [[CPView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(frame)-100, 42)];
    	var dataView = [CPTextField labelWithTitle:[[lineItems objectAtIndex:i] identifier]];
    	[dataView setCenter:CGPointMake([tempView center].x, 14)];
		[tempView addSubview:dataView];
		var dataView2 = [CPTextField labelWithTitle:[[lineItems objectAtIndex:i] value]];
    	[dataView2 setCenter:CGPointMake([tempView center].x, 28)];
    	[tempView addSubview:dataView2];
		[arrayOfDataViews addObject:tempView];
	}

	[listOfResources setContent:arrayOfDataViews];
	[listOfResources reloadContent];
	
	[self addSubview:listOfResources];	
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	for(var i = 0; i < [[aCollectionView content] count]; i++)
	{
		[[[aCollectionView content] objectAtIndex:i] setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
	}
	
	var selectedIndex = [[aCollectionView selectionIndexes] firstIndex];
	[[[aCollectionView content] objectAtIndex:selectedIndex] setBackgroundColor:[CPColor colorWithHexString:@"CCCCFF"]];
	
	[self setupLineItemsWithIndex:selectedIndex];
}

@end

@implementation OLResourceView : CPView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
        [self setAutoresizingMask:CPViewWidthSizable];
    }
    
    return self;
}

- (void)setRepresentedObject:(JSObject)anObject
{
    [self addSubview:anObject];
    [self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
}

@end

@implementation OLLineItemView : CPView
{
}

- (id)init
{
	if(self = [super init])
	{
        [self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
        [self setAutoresizingMask:CPViewWidthSizable];
	}
	return self;
}

- (void)setRepresentedObject:(JSObject)anObject
{
    [self addSubview:anObject];
    [self setBackgroundColor:[CPColor colorWithCalibratedWhite:0.926 alpha:1.000]];
}


@end
