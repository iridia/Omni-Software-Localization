@import <AppKit/CPView.j>

@import "OLView.j"
@import "OLLineItemView.j"
@import "OLResourceView.j"
@import "OLLineItemEditView.j"
@import "../models/OLResourceBundle.j"

/*!
 * The view for displaying relevant resource bundle information.
 */
@implementation OLResourceBundleView : CPView
{
	CPCollectionView _listOfResourcesView;
	CPCollectionView _listOfLineItemsView;
	OLView _editView;
	OLResourceBundle _resourceBundle @accessors(property=resourceBundle, readonly);
	CPTextField _titleView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
	{
        _titleView = createTitleView(self);
		[self addSubview:_titleView];
		
        _listOfResourcesView = createListOfResourcesView(self);
		[self addSubview:_listOfResourcesView];
		
		_listOfLineItemsView = createListOfLineItemsView(self);
		[self addSubview:_listOfLineItemsView];
		
		_editView = createEditView(self);
		[self addSubview:_editView];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    if (keyPath === @"bundle")
    {
        _resourceBundle = [object bundle];
        [_listOfResourcesView setContent:[_resourceBundle resources]];
        [_listOfResourcesView reloadContent];
        
        [_titleView setStringValue:@"Resource Bundle in " + [[_resourceBundle language] name]];
        [_titleView sizeToFit];
        [_titleView setCenter:CGPointMake(CGRectGetWidth([self bounds]) / 2.0, 50)];
    }
}

- (void)setupLineItemsWithIndex:(int)index
{
	var resource = [[_resourceBundle resources] objectAtIndex:index];
	
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
		var selectedIndex = [[aCollectionView selectionIndexes] firstIndex];
		var selectedLineItem = [[aCollectionView content] objectAtIndex:selectedIndex];
		
		[_editView setContent:selectedLineItem];
	}
}

- (void)controlTextDidChange:(CPNotification)aNotification
{
	[_listOfLineItemsView reloadContent];
}

@end

function createTitleView(self)
{
    var title = [CPTextField labelWithTitle:@""];
	
	[title setFont:[CPFont boldFontWithName:"Tahoma" size:24]];
	[title setBezeled:YES];
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
    [_listOfResourcesView setMinItemSize:CGSizeMake(CGRectGetWidth([self bounds])-100, 42.0)];
    [_listOfResourcesView setMaxItemSize:CGSizeMake(CGRectGetWidth([self bounds])-100, 42.0)];
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
    [_listOfLineItemsView setMinItemSize:CGSizeMake(CGRectGetWidth([self bounds])-100, 42.0)];
    [_listOfLineItemsView setMaxItemSize:CGSizeMake(CGRectGetWidth([self bounds])-100, 42.0)];
    [_listOfLineItemsView setDelegate:self];
    
    return _listOfLineItemsView;
}

function createEditView(self)
{
	var width = CGRectGetWidth([self bounds])-100;
	var _editView = [[OLLineItemEditView alloc] initWithFrame:CGRectMake(50+width/2, 550, width/2, 200)];
	[_editView setDelegate:self];
	return _editView;
}
