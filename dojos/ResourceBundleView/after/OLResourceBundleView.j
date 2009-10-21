@import "OLView.j"
@import "OLLineItemView.j"
@import "OLResourceView.j"

/*!
 * The view for displaying relevant resource bundle information.
 */
@implementation OLResourceBundleView : OLView
{
	CPCollectionView _listOfResourcesView;
	CPCollectionView _listOfLineItemsView;
}

- (id)initWithFrame:(CGRect)frame withController:(CPObject)controller
{
	if(self = [super initWithFrame:frame withController:controller])
	{
		var resourceBundle = [controller bundle];
		[self addSubview:createTitleView(self)];
		
        _listOfResourcesView = createListOfResourcesView(self);
		[_listOfResourcesView setContent:[resourceBundle resources]];
		[_listOfResourcesView reloadContent];
		[self addSubview:_listOfResourcesView];
		
		_listOfLineItemsView = createListOfLineItemsView(self);
		[self addSubview:_listOfLineItemsView];
	}
	return self;
}

- (void)setupLineItemsWithIndex:(int)index
{
	var resource = [[[[self controller] bundle] resources] objectAtIndex:index];
	
	var lineItems = [resource lineItems];
    
	[_listOfLineItemsView setContent:lineItems];
	[_listOfLineItemsView reloadContent];	
}

- (void)collectionViewDidChangeSelection:(CPCollectionView)aCollectionView
{
	if ([aCollectionView isEqual:_listOfResourcesView])
	{
		var selectedIndex = [[aCollectionView selectionIndexes] firstIndex];
	
		[self setupLineItemsWithIndex:selectedIndex];	
	}
	else if ([aCollectionView isEqual:_listOfLineItemsView])
	{
		// do something
	}
}

@end

function createTitleView(self)
{
	var controller = [self controller];
	var resourceBundle = [controller bundle];
	var title = [CPTextField labelWithTitle:"Resource Bundle in " + [[resourceBundle language] name]];
	
	[title setFont:[CPFont boldFontWithName:"Tahoma" size:24]];
	[title setBezeled:YES];
	[title sizeToFit];
	[title setCenter:CGPointMake([self center].x, 50)];
	[title setBackgroundColor:[CPColor whiteColor]];
	
	return title;
}

function createListOfResourcesView(self)
{
	var dataView = [[CPCollectionViewItem alloc] init];
    [dataView setView:[[OLResourceView alloc] initWithFrame:CGRectMakeZero()]];
    
    var _listOfResourcesView = [[CPCollectionView alloc] initWithFrame:CGRectMake(50, 100, CGRectGetWidth([self bounds])-100, 500)];
    [_listOfResourcesView setItemPrototype:dataView];
    [_listOfResourcesView setVerticalMargin:0.0];
    [_listOfResourcesView setMinItemSize:CGSizeMake(500.0, 42.0)];
    [_listOfResourcesView setMaxItemSize:CGSizeMake(10000.0, 42.0)];
    [_listOfResourcesView setDelegate:self];
    
    return _listOfResourcesView;
}

function createListOfLineItemsView(self)
{
	var lineItemView = [[CPCollectionViewItem alloc] init];
	[lineItemView setView:[[OLLineItemView alloc] initWithFrame:CGRectMakeZero()]];
	
	var _listOfLineItemsView = [[CPCollectionView alloc] initWithFrame:CGRectMake(50, 300, CGRectGetWidth([self bounds])-100, 200)];
    [_listOfLineItemsView setItemPrototype:lineItemView];
    [_listOfLineItemsView setVerticalMargin:0.0];
    [_listOfLineItemsView setMinItemSize:CGSizeMake(500.0, 42.0)];
    [_listOfLineItemsView setMaxItemSize:CGSizeMake(10000.0, 42.0)];
    [_listOfLineItemsView setDelegate:self];
    
    return _listOfLineItemsView;
}