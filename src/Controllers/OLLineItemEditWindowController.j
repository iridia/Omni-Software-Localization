
@import <Foundation/CPObject.j>

@implementation OLLineItemEditWindowController : CPWindowController
{
    @outlet     CPTextField comment;
    @outlet     CPTextField value;
    
    OLLineItem  lineItem;
    CPView      commentsView;
    CPView      editView;
    
    CPCollectionView collectionView;
    CPTextField commentTextField;
    CPButton    commentButton;
    
    id          delegate            @accessors;
}

- (id)initWithWindowCibName:(CPString)aName lineItem:(OLLineItem)aLineItem
{
    if(self = [super initWithWindowCibPath:"Resources/"+aName owner:self])
    {
        [value setTarget:self];
    	[value setAction:@selector(done:)];
    	[self setLineItem:aLineItem];
    }
    return self;
}

- (void)awakeFromCib
{
	[comment setLineBreakMode:CPLineBreakByWordWrapping];
	[value setLineBreakMode:CPLineBreakByWordWrapping];
	
	editView = [[self window] contentView];
    
    [self setupCommentsView];
}

- (void)setupCommentsView
{
    commentsView = [[CPView alloc] initWithFrame:[[[self window] contentView] bounds]];
    [commentsView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([commentsView bounds]), CGRectGetWidth([commentsView bounds]) - 170.0)];
    [scrollView setAutohidesScrollers:YES];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    
    var prototype = [[CPCollectionViewItem alloc] init];
    [prototype setView:[[OLCommentView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([scrollView bounds]), 70.0)]];
    
    collectionView = [[CPCollectionView alloc] initWithFrame:[scrollView bounds]];
    [collectionView setItemPrototype:prototype];
    [collectionView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [collectionView setMaxNumberOfColumns:1];
    [collectionView setVerticalMargin:10.0];
    [collectionView setMinItemSize:CPMakeSize(100.0, 50.0)];
    [collectionView setMaxItemSize:CPMakeSize(10000.0, 50.0)];
    
    [scrollView setDocumentView:collectionView];
    [commentsView addSubview:scrollView];
    
    commentTextField = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([commentsView bounds]) - 18.0, 50.0)];
    [commentTextField setEditable:YES];
	[commentTextField setBezeled:YES];
	[commentTextField setLineBreakMode:CPLineBreakByWordWrapping];
	[commentTextField setTarget:self];
	[commentTextField setAction:@selector(saveComment:)];
    [commentsView addSubview:commentTextField positioned:CPViewBelow | CPViewWidthCentered relativeTo:scrollView withPadding:10.0];
    
    var backButton = [CPButton buttonWithTitle:@"Back"];
    [backButton setTarget:self];
    [backButton setAction:@selector(switchToEditView:)];
    [commentsView addSubview:backButton positioned:CPViewLeftAligned | CPViewBottomAligned relativeTo:commentsView withPadding:10.0];
    
    commentButton = [CPButton buttonWithTitle:@"Comment"];
    [commentButton setTarget:self];
    [commentButton setAction:@selector(saveComment:)];
    [commentsView addSubview:commentButton positioned:CPViewRightAligned | CPViewBottomAligned relativeTo:commentsView withPadding:10.0];
}

- (void)showWindow:(id)sender
{
    [[CPApplication sharedApplication] runModalForWindow:[self window]];
}

- (@action)done:(id)sender
{
    [[self window] close];
}

- (@action)next:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(nextLineItem)])
    {
        [[self delegate] nextLineItem];
    }
}

- (@action)previous:(id)sender
{
    if([[self delegate] respondsToSelector:@selector(previousLineItem)])
    {
        [[self delegate] previousLineItem];
    }
}

- (void)switchToEditView:(id)sender
{
    [[self window] setTitle:[lineItem identifier]];
    [[self window] setContentView:editView];
    [commentTextField setStringValue:@""];
}

- (@action)switchToCommentView:(id)sender
{
    [[self window] setTitle:@"Comments"];
    [[self window] setDefaultButton:commentButton];
    [[self window] setContentView:commentsView];
}

- (void)saveComment:(id)sender
{
    if ([commentTextField stringValue] === @"")
        return;

    if ([[self delegate] respondsToSelector:@selector(saveCommentWithOptions:)])
    {
        var options = [CPDictionary dictionary];
        [options setObject:[commentTextField stringValue] forKey:@"content"];
        [options setObject:lineItem forKey:@"item"];
        [[self delegate] saveCommentWithOptions:options];
        [commentTextField setStringValue:@""];
    	[collectionView setContent:[lineItem comments]];
    	[collectionView reloadContent];
    }
}

- (void)windowWillClose:(id)window
{
	[[CPApplication sharedApplication] stopModal];
}

- (void)setLineItem:(OLLineItem)aLineItem
{
    lineItem = aLineItem;
    [[self window] setTitle:[lineItem identifier]];
    [value setStringValue:[lineItem value]];
	[comment setStringValue:[lineItem comment]];
	[collectionView setContent:[lineItem comments]];
	[collectionView reloadContent];

	[[self window] makeFirstResponder:value];
}

- (void)controlTextDidChange:(CPNotification)aNotification
{
    [lineItem setValue:[value stringValue]];
}

- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
	[self saveResource];
}

- (void)controlTextDidBlur:(CPNotification)aNotification
{
    [self controlTextDidEndEditing:aNotification]; // FIXME: This seems wrong, but it works.
}

- (void)saveResource
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:@"OLProjectDidChangeNotification"
        object:lineItem];
}

@end

@implementation OLLineItemEditWindowController (KVO)

- (void)observeValueForKeyPath:(CPString)keyPath ofObject:(id)object change:(CPDictionary)change context:(void)context
{
    switch (keyPath)
    {
        case @"selectedLineItem":
            [self setLineItem:[object selectedLineItem]];
            break;
        default:
            CPLog.warn(@"%s: Unhandled keypath: %s, in: %s", _cmd, keyPath, [self className]);
            break;
    }
}

@end

@implementation OLCommentView :CPView
{
    CPTextField     user;
    CPTextField     comment;
    CPView          padding;
}

- (void)setRepresentedObject:(OLComment)aComment
{
    if (!padding)
    {
        padding = [[CPView alloc] initWithFrame:CGRectInset([self bounds], 5.0, 0.0)];
        [padding setBackgroundColor:[CPColor whiteColor]];
        [self addSubview:padding];
    }
    if (!user)
    {
        user = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [user setFont:[CPFont boldSystemFontOfSize:12.0]];
        [padding addSubview:user];
    }
    if (!comment)
    {
        comment = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
        [comment setFont:[CPFont systemFontOfSize:12.0]];
        [padding addSubview:comment];
    }
    
    [user setStringValue:[aComment userEmail]];
    [user sizeToFit];
    
    [comment setStringValue:[aComment content]];
    [comment sizeToFit];
    [comment setFrameOrigin:CPMakePoint(0.0, CGRectGetMaxY([user bounds]) + 5.0)];
}

@end