@import "CPUploadButton.j"
@import "OLProjectController.j"

/*!
 * OLUploadEmptyGlossaryViewController
 *
 * The screen that is displayed when a glossary is created, but no file associated with it.
 */
 
var OLResourceEditorViewIdentifierColumnHeader = @"OLGlossaryViewIdentifierColumnHeader";
var OLResourceEditorViewValueColumnHeader = @"OLGlossaryViewValueColumnHeader";

@implementation OLGlossaryViewController : CPViewController
{
	id delegate @accessors;
	OLGlossary glossary @accessors;
	
	CPTableView lineItemsTableView;
	CPScrollView scrollView;
	
	@outlet CPView noItemView;
	@outlet CPView tableItemsView;
}

-(id)initWithCibName:(CPString)aName bundle:(CPBundle)aCibBundleOrNil owner:(id)anOwner
{
	return [self initWithCibName:aName bundle:aCibBundleOrNil owner:self];
}

-(id)awakeFromCib
{
	scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) -  32.0)];
	[scrollView setAutohidesScrollers:YES];
	[scrollView setAutoresizingMask:CPViewWidthSizable | CPViewMaxYMargin];
 
	lineItemsTableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
	[lineItemsTableView setDataSource:self];
	[lineItemsTableView setUsesAlternatingRowBackgroundColors:YES];
	[lineItemsTableView setAutoresizingMask:CPViewWidthSizable | CPViewWidthSizable];
	//[lineItemsTableView setTarget:self];
	//[lineItemsTableView setDoubleAction:@selector(edit:)];

	// define the header color
	var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
	[[lineItemsTableView cornerView] setBackgroundColor:headerColor];
	
	var column = [[CPTableColumn alloc] initWithIdentifier:OLResourceEditorViewIdentifierColumnHeader];
	[[column headerView] setStringValue:@"Identifier"];
	[[column headerView] setBackgroundColor:headerColor];
	[column setWidth:200.0];
	[lineItemsTableView addTableColumn:column];
 
	var column = [[CPTableColumn alloc] initWithIdentifier:OLResourceEditorViewValueColumnHeader];
	[[column headerView] setStringValue:@"Value"];
	[[column headerView] setBackgroundColor:headerColor];
	[column setWidth:(CGRectGetWidth(aFrame) - 200.0)];
	[lineItemsTableView addTableColumn:column];
	
	[_scrollView setDocumentView:lineItemsTableView];
	[self addSubview:scrollView];
	
	if( [[glossary listOfLineItems] count] == 0)
	{
		view = noItemView;
		
	}
	else
	{
		view = tableItemsView;
	}
}

-(void)uploadButton:(CPButton)aButton didFinishUploadWithData:(CPString)someData
{	
	var jsonResponse = eval("("+someData+")");
	var lineItemKeys = jsonResponse.dict.key;
	var lineItemStrings = jsonResponse.dict.string;
 
	if(jsonResponse.fileType == "strings")
	{
		var lineItemComments = jsonResponse.comments_dict.string;
 
		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[glossary addLineItem:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i] comment:lineItemComments[i]]];
		}	
	}
	
	[glossary save];
}

@end

@implementation OLGlossaryViewController (CPTableViewDataSource)
 
- (int)numberOfRowsInTableView:(CPTableView)resourceTableView
{
    return [[glossary listOfLineItems] count];
}
 
- (id)tableView:(CPTableView)glossaryTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    if ([tableColumn identifier] === OLResourceEditorViewIdentifierColumnHeader)
    {
        return [[[glossary listOfLineItems] objectAtIndex:row] identifier];
    }
    else if ([tableColumn identifier] === OLResourceEditorViewValueColumnHeader)
    {
        return [[[glossary listOfLineItems] objectAtIndex:row] value];
    }
}

@end