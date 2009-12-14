@import "../models/OLResource.j"

var OLResourceEditorViewIdentifierColumnHeader = @"OLResourceEditorViewIdentifierColumnHeader";
var OLResourceEditorViewValueColumnHeader = @"OLResourceEditorViewValueColumnHeader";

@implementation OLResourceEditorView : CPView
{
    CPTableView     _lineItemsTableView     @accessors(property=lineItemsTableView, readonly);
    CPScrollView    _scrollView;
    CPTextField     _votes                  @accessors(property=votes, readonly);
    
    CPButton        voteDownButton;
    CPButton        voteUpButton;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {     
        _scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame) -  32.0)];
		[_scrollView setAutohidesScrollers:YES];
		[_scrollView setAutoresizingMask:CPViewWidthSizable | CPViewMaxYMargin];
		
		_lineItemsTableView = [[CPTableView alloc] initWithFrame:[_scrollView bounds]];
		[_lineItemsTableView setUsesAlternatingRowBackgroundColors:YES];
		[_lineItemsTableView setAutoresizingMask:CPViewWidthSizable | CPViewWidthSizable];
				
		// define the header color
		var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"Images/button-bezel-center.png"]]];
		[[_lineItemsTableView cornerView] setBackgroundColor:headerColor];
		
		// add the first column
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourceEditorViewIdentifierColumnHeader];
		[[column headerView] setStringValue:@"Identifier"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:200.0];
		[_lineItemsTableView addTableColumn:column];
		
		var column = [[CPTableColumn alloc] initWithIdentifier:OLResourceEditorViewValueColumnHeader];
		[[column headerView] setStringValue:@"Value"];
		[[column headerView] setBackgroundColor:headerColor];
		[column setWidth:(CGRectGetWidth(aFrame) - 200.0)];
		[_lineItemsTableView addTableColumn:column];
		
		[_scrollView setDocumentView:_lineItemsTableView];
		[self addSubview:_scrollView];

		var bottomBar = [[CPView alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight([_scrollView bounds]), CGRectGetWidth(aFrame), 32.0)];
		[bottomBar setBackgroundColor:[CPColor lightGrayColor]];
		[bottomBar setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
		
		voteUpButton = [CPButton buttonWithTitle:@"Vote Up"];
		[voteUpButton setAutoresizingMask:CPViewMaxXMargin];
		[voteUpButton setFrameOrigin:CPMakePoint(10.0, 4.0)];
        [voteUpButton setTarget:self];
        [voteUpButton setAction:@selector(voteUp:)];
        [bottomBar addSubview:voteUpButton];
        
        voteDownButton = [CPButton buttonWithTitle:@"Vote Down"];
        [voteDownButton setAutoresizingMask:CPViewMaxXMargin];
        [voteDownButton setTarget:self];
        [voteDownButton setAction:@selector(voteDown:)];
        [voteDownButton setFrameOrigin:CPMakePoint(CGRectGetWidth([voteUpButton bounds]) + 15.0, 4.0)];
        [bottomBar addSubview:voteDownButton];
        
        _votes = [CPTextField labelWithTitle:@"Votes: "];
        [_votes setFont:[CPFont systemFontOfSize:14.0]];
        [_votes sizeToFit];
        [_votes setAutoresizingMask:CPViewMaxXMargin];
        [_votes setFrameOrigin:CPMakePoint(CGRectGetWidth([voteUpButton bounds]) + CGRectGetWidth([voteDownButton bounds]) + 30.0, 7.0)];
        [bottomBar addSubview:_votes];

        [self addSubview:bottomBar];
    }
    
    return self;
}

- (void)setVoteTarget:(id)target downAction:(SEL)downAction upAction:(SEL)upAction
{
    [voteDownButton setTarget:target];
    [voteUpButton setTarget:target];
    
    [voteDownButton setAction:downAction];
    [voteUpButton setAction:upAction];
}

@end

@implementation CPTableView (DoubleClick)

- (void)mouseDown:(CPEvent)anEvent
{
    if ([anEvent clickCount] == 2)
	{
		var index = [[self selectedRowIndexes] firstIndex];
		
		if(index >= 0)
		{
			objj_msgSend([self target], [self doubleAction], self);	
		}
	}


	[super mouseDown:anEvent];
}

@end
