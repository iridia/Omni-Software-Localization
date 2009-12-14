@import <Foundation/CPObject.j>

@import "../Models/OLGlossary.j"

// Manages an array of glossaries
@implementation OLGlossaryController : CPObject
{
    CPArray                     glossaries     	            @accessors;
	OLGlossary	                selectedGlossary	        @accessors;
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
	var glossariesList = [OLGlossary list];
	for (var i = 0; i < [glossariesList count]; i++)
	{
		[self addGlossary:[glossariesList objectAtIndex:i]];
	}
}x

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
//	var project = [[OLProject alloc] initWithName:jsonResponse.fileName];
//
//	var resources = [CPArray array];
//
//	for(var i = 0; i < jsonResponse.resourcebundles.length; i++)
//	{		
//		for(var j = 0; j < jsonResponse.resourcebundles[i].resources.length; j++)
//		{
//			var theResource = jsonResponse.resourcebundles[i].resources[j];
//			var lineItems = [self lineItemsFromResponse:theResource];
//			
//			[resources addObject:[[OLResource alloc] initWithFileName:theResource.fileName fileType:theResource.fileType lineItems:lineItems]];
//		}
//	}
//	
//	var resourceBundle = [[OLResourceBundle alloc] initWithResources:resources language:[OLLanguage english]];
//	[project addResourceBundle:resourceBundle];
//
//	[self addProject:project];
//	[project save];
	alert(_cmd);
}

- (void)didReceiveOutlineViewSelectionDidChangeNotification:(CPNotification)notification
{
	var outlineView = [notification object];

	var selectedRow = [[outlineView selectedRowIndexes] firstIndex];
	var item = [outlineView itemAtRow:selectedRow];

	var parent = [outlineView parentForItem:item];

	if (item === @"Glossaries")
	{
		alert("hi");
		[self setSelectedGlossary:item];
	}
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

@implementation OLGlossaryController (OLGlossaryTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [glossaries count];
}

- (id)tableView:(CPTableView)resourceTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
	var lineItem = [[selectedGlossary lineItems] objectAtIndex:row];
	
    if ([tableColumn identifier] === OLResourceEditorViewIdentifierColumnHeader)
    {
        return [lineItem identifier];
    }
    else if ([tableColumn identifier] === OLResourceEditorViewValueColumnHeader)
    {
        return [lineItem value];
    }
}

@end
