@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "../Models/OLGlossary.j"
@import "../Views/OLGlossariesView.j"
@import "OLContentViewController.j"
@import "OLUploadController.j"


var OLGlossaryViewIdentifierColumnHeader = @"OLGlossaryViewIdentifierColumnHeader";
var OLGlossaryViewValueColumnHeader = @"OLGlossaryViewValueColumnHeader";

// Manages an array of glossaries
@implementation OLGlossaryController : CPObject
{
    CPArray             glossaries     	    @accessors;
	OLGlossary	        selectedGlossary	@accessors;
	OLGlossariesView    glossariesView;
}

- (id)init
{
    if(self = [super init])
    {
    	glossariesView = [[OLGlossariesView alloc] initWithFrame:CGRectMake(0.0, 0.0, 500.0, 500.0)];
    	[glossariesView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    	[glossariesView setGlossaryController:self];
    	
		glossaries = [CPArray array];

		[[CPNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(didReceiveParseServerResponseNotification:)
			name:OLUploadControllerDidParseServerResponse
			object:nil];
		
		[[CPNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(didReceiveOutlineViewSelectionDidChangeNotification:)
			name:CPOutlineViewSelectionDidChangeNotification
			object:nil];

    }
    return self;
}

- (void)loadGlossaries
{
	[OLGlossary listWithCallback:function(glossary){
	    if (glossary)
	    {
            [self addGlossary:glossary];
	    }
	}];
}

- (void)insertObject:(OLGlossary)glossary inGlossariesAtIndex:(int)index
{
    [glossaries insertObject:glossary atIndex:index];
}

- (void)addGlossary:(OLGlossary)glossary
{
    [self insertObject:glossary inGlossariesAtIndex:[glossaries count]];
}

- (void)createNewGlossary:(JSObject)jsonResponse
{	
    var glossary = [[OLGlossary alloc] initWithName:jsonResponse.fileName];

    var lineItems = [CPArray array];
    
    var keys = jsonResponse.dict.key;
    var values = jsonResponse.dict.string;
    
    for(var i = 0; i < keys.length; i++)
    {
        var lineItem = [[OLLineItem alloc] initWithIdentifier:keys[i] value:values[i] comment:nil];
        [glossary addLineItem:lineItem];
    }
    
    [self addGlossary:glossary];
    [glossary save];
}

- (void)didReceiveParseServerResponseNotification:(CPNotification)notification
{
	var jsonResponse = [[notification object] jsonResponse];

	if (jsonResponse.fileType === @"strings")
	{
		[self createNewGlossary:jsonResponse]
	}
}

@end

@implementation OLGlossaryController (OLGlossaryTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [[selectedGlossary lineItems] count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
	var lineItem = [[selectedGlossary lineItems] objectAtIndex:row];
	
    if ([tableColumn identifier] === OLGlossaryViewIdentifierColumnHeader)
    {
        return [lineItem identifier];
    }
    else if ([tableColumn identifier] === OLGlossaryViewValueColumnHeader)
    {
        return [lineItem value];
    }
}

@end

@implementation OLGlossaryController (SidebarItem)

- (CPArray)sidebarItems
{
    return glossaries;
}

- (CPString)sidebarName
{
    return @"Glossaries";
}

- (BOOL)shouldExpandSidebarItemOnReload
{
    return YES;
}

- (void)didReceiveOutlineViewSelectionDidChangeNotification:(CPNotification)notification
{
	var outlineView = [notification object];

	var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
	var item = [outlineView itemAtRow:selectedRow];

	var parent = [outlineView parentForItem:item];

	if (parent === self)
	{
	    if (item !== selectedGlossary)
	    {
    		[self setSelectedGlossary:item];
    		[[glossariesView tableView] reloadData];
    		[glossariesView setTitle:[item name]];
    		
    		// tell content view controller to update view
    		[[CPNotificationCenter defaultCenter]
    		  postNotificationName:OLContentViewControllerShouldUpdateContentViewByUserInfo
    		  object:self
    		  userInfo:[CPDictionary dictionaryWithObject:glossariesView forKey:@"view"]];
    	}
	}
	else
	{
	    [self setSelectedGlossary:nil];
	}
}

@end
