@import <Foundation/CPObject.j>
@import <AppKit/CPOutlineView.j>

@import "../Models/OLGlossary.j"
@import "../Views/OLGlossariesView.j"


var OLGlossaryViewIdentifierColumnHeader = @"OLGlossaryViewIdentifierColumnHeader";
var OLGlossaryViewValueColumnHeader = @"OLGlossaryViewValueColumnHeader";

// Manages an array of glossaries
@implementation OLGlossaryController : CPObject
{
    CPArray             glossaries     	    @accessors;
	OLGlossary	        selectedGlossary	@accessors;
	OLGlossariesView    glossariesView      @accessors;
}

- (id)init
{
    if(self = [super init])
    {        
		glossaries = [CPArray array];

		[[CPNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(didReceiveParseServerResponseNotification:)
			name:@"OLUploadControllerDidParseServerResponse"
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
	var glossariesList = [OLGlossary listWithCallback:function(glossary){[self addGlossary:glossary];}];
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

- (void)lineItemsFromResponse:(JSObject)jsonResponse
{
	var result = [CPArray array];
	var lineItemKeys = jsonResponse.dict.key;
	var lineItemStrings = jsonResponse.dict.string;
	
	if(jsonResponse.fileType == "strings")
	{
		var lineItemComments = jsonResponse.comments_dict.string;

		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[result addObject:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i] comment:lineItemComments[i]]];
		}	
	}
	else
	{
		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[result addObject:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i]]];
		}
	}
	return result;
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

- (CPView)contentView
{
    return glossariesView;
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
    		[[[self glossariesView] tableView] reloadData];
    	}
	}
	else
	{
	    [self setSelectedGlossary:nil];
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
