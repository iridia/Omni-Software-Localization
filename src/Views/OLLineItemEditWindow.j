@import <AppKit/CPWindow.j>
// @import "../Controllers/OLLineItemEditWindowController.j"
@import "OLCommentView.j"

@implementation OLLineItemEditWindow : CPWindow
{
    id                  delegate                @accessors;
    CPTextField         title;
    CPView              commentsView;
    
    CPTextField         commentTextField        @accessors(readonly);
    CPCollectionView    collectionView;
    
    CPTextField         valueTextField          @accessors(readonly);
    CPTextField         comment;
    CPTextField         englishValue;
    
    CPButton            left;
    CPButton            right;
    CPButton            close;
}

- (id)initWithContentRect:(CGRect)aFrame styleMask:(CPWindowStyleMask)aStyleMask
{
    self = [super initWithContentRect:aFrame styleMask:aStyleMask];
    if(self)
    {
        var contentView = [self contentView];
        
        [self setBackgroundColor:[CPColor colorWithCalibratedRed:0.0 green:0.0 blue:0.0 alpha:0.80]];
        
        close = [CPButton buttonWithTitle:@"Close"];
        [close setTarget:self];
        [close setAction:@selector(close:)];
        [close setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
        [close setWidth:150];
        
        right = [CPButton buttonWithTitle:@">"];
        [right setTarget:self];
        [right setAction:@selector(right:)];
        [right setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin | CPViewMaxYMargin];
        [right setFont:[CPFont boldSystemFontOfSize:48.0]];
        [right setBordered:NO]
        [right setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/rightarrow.png"]];
        [right setAlternateImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/rightarrow-pressed.png"]];
        [right setFrameSize:CGSizeMake(91, 394)];
        
        left = [CPButton buttonWithTitle:@""];
        [left setTarget:self];
        [left setAction:@selector(left:)];
        [left setAutoresizingMask:CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin];
        [left setFont:[CPFont boldSystemFontOfSize:48.0]];
        [left setBordered:NO];
        [left setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/leftarrow.png"]];
        [left setAlternateImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/leftarrow-pressed.png"]];
        [left setFrameSize:CGSizeMake(91, 394)];
        
        var lineItemView = [[CPView alloc] initWithFrame:CGRectMake(0, 0,650,500)];
        [lineItemView setAutoresizingMask:CPViewMaxXMargin | CPViewMinYMargin | CPViewMaxYMargin | CPViewMinXMargin];
        [lineItemView setBackgroundColor:[CPColor colorWithCalibratedWhite:0.95 alpha:1.0]];
        
        var lineItemViewBorder = [[CPView alloc] initWithFrame:CGRectInset([lineItemView frame], -2, -2)];
        [lineItemViewBorder setBackgroundColor:[CPColor colorWithCalibratedWhite:1.0 alpha:0.5]];
        [lineItemViewBorder setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [contentView addSubview:lineItemViewBorder];
        
        title = [CPTextField labelWithTitle:@"Localizable.strings"];
        [title setFont:[CPFont boldSystemFontOfSize:48.0]];
        [title setTextColor:[CPColor colorWithCalibratedWhite:0.0 alpha:0.4]];
        [title setTextShadowColor:[CPColor colorWithCalibratedWhite:1.0 alpha:0.4]];
        [title setTextShadowOffset:CGSizeMake(1, 1)];
        [title setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];
        [title sizeToFit];
        
        var commentLabel = [CPTextField labelWithTitle:@"Description"];
        [commentLabel setFont:[CPFont boldSystemFontOfSize:24.0]];
        [commentLabel setTextShadowColor:[CPColor whiteColor]];
        [commentLabel setTextShadowOffset:CGSizeMake(1, 1)];
        [commentLabel sizeToFit];
        comment = [CPTextField labelWithTitle:@""];
        var commentBox = [[CPBox alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([lineItemView bounds])/2 - 20.0, 100)];
        [commentBox setContentViewMargins:CGSizeMake(12.0, 12.0)];
        [commentBox setContentView:comment];
        [commentBox setBackgroundColor:[CPColor colorWithCalibratedWhite:0.9 alpha:1.0]];
        [commentBox setBorderWidth:1.0];
        [commentBox setAutoresizingMask:CPViewWidthSizable | CPViewMaxXMargin];
        [commentBox setBorderColor:[CPColor blackColor]];
        [commentBox setBorderType:CPLineBorder];
        [comment setBezeled:NO];
        [comment setLineBreakMode:CPLineBreakByWordWrapping];
        
        var englishValueLabel = [CPTextField labelWithTitle:@"English Value"];
        [englishValueLabel setFont:[CPFont boldSystemFontOfSize:24.0]];
        [englishValueLabel setTextShadowColor:[CPColor whiteColor]];
        [englishValueLabel setTextShadowOffset:CGSizeMake(1, 1)];
        [englishValueLabel sizeToFit];
        englishValue = [CPTextField labelWithTitle:@""];
        var englishValueBox = [[CPBox alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([lineItemView bounds])/2 - 20.0, 100)];
        [englishValueBox setContentViewMargins:CGSizeMake(12.0, 12.0)];
        [englishValueBox setContentView:englishValue];
        [englishValueBox setBackgroundColor:[CPColor colorWithCalibratedWhite:0.9 alpha:1.0]];
        [englishValueBox setBorderWidth:1.0];
        [englishValueBox setBorderColor:[CPColor blackColor]];
        [englishValueBox setAutoresizingMask:CPViewWidthSizable | CPViewMaxXMargin];
        [englishValueBox setBorderType:CPLineBorder];
        [englishValue setBezeled:NO];
        [englishValue setLineBreakMode:CPLineBreakByWordWrapping];
        
        valueTextField = [CPTextField textFieldWithStringValue:@"" placeholder:@"" width:CGRectGetWidth([lineItemView bounds]) * 0.5 - 12.0];
        var valueBox = [[CPBox alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([lineItemView bounds])/2 - 20.0, 100)];
        [valueBox setContentViewMargins:CGSizeMake(12.0, 12.0)];
        [valueBox setContentView:valueTextField];
        [valueBox setBackgroundColor:[CPColor colorWithCalibratedWhite:0.9 alpha:1.0]];
        [valueBox setAutoresizingMask:CPViewWidthSizable | CPViewMaxXMargin];
        [valueBox setBorderWidth:1.0];
        [valueBox setBorderColor:[CPColor blackColor]];
        [valueBox setBorderType:CPLineBorder];
        [valueTextField setBezeled:NO];
        [valueTextField setLineBreakMode:CPLineBreakByWordWrapping];
        
        var clickToEdit = [CPTextField labelWithTitle:@"click to edit"];
        [clickToEdit setTextColor:[CPColor grayColor]];
        
        var valueLabel = [CPTextField labelWithTitle:@"Value"];
        [valueLabel setFont:[CPFont boldSystemFontOfSize:24.0]];
        [valueLabel setTextShadowColor:[CPColor whiteColor]];
        [valueLabel setTextShadowOffset:CGSizeMake(1, 1)];
        [valueLabel sizeToFit];
        
        [self _makeCommentsView:CGRectMake(0, 0, CGRectGetWidth([lineItemView bounds]) * 0.5, CGRectGetHeight([lineItemView bounds]))];
        
        [lineItemView addSubview:commentBox positioned:CPViewLeftAligned | CPViewTopAligned relativeTo:lineItemView withPadding:24.0];
        [lineItemView addSubview:englishValueBox positioned:CPViewBelow | CPViewLeftAligned relativeTo:commentBox withPadding:24.0];
        [lineItemView addSubview:valueBox positioned:CPViewBelow | CPViewLeftAligned relativeTo:englishValueBox withPadding:24.0];
        [lineItemView addSubview:commentLabel];
        [lineItemView addSubview:englishValueLabel];
        [lineItemView addSubview:valueLabel];
        [lineItemView addSubview:clickToEdit];
        
        [commentLabel setCenter:CGPointMake([commentBox center].x, [commentBox frameOrigin].y)];
        [englishValueLabel setCenter:CGPointMake([englishValueBox center].x, [englishValueBox frameOrigin].y)];
        [valueLabel setCenter:CGPointMake([valueBox center].x, [valueBox frameOrigin].y)];
        
        [clickToEdit setNextResponder:valueTextField];
        [clickToEdit setFrameOrigin:CGPointMake([valueBox frameOrigin].x + CGRectGetWidth([valueBox bounds]) - CGRectGetWidth([clickToEdit bounds]) - 12.0, [valueBox frameOrigin].y + CGRectGetHeight([valueBox bounds]) - CGRectGetHeight([clickToEdit bounds]) - 12.0)];
        
        [lineItemView addSubview:commentsView positioned:CPViewRightAligned | CPViewTopAligned relativeTo:lineItemView withPadding:12.0];
        
        [contentView addSubview:close positioned:CPViewRightAligned | CPViewBottomAligned relativeTo:contentView withPadding:24.0];
        [contentView addSubview:right positioned:CPViewRightAligned | CPViewHeightCentered relativeTo:contentView withPadding:24.0];
        [contentView addSubview:left positioned:CPViewLeftAligned | CPViewHeightCentered relativeTo:contentView withPadding:24.0];
        [contentView addSubview:lineItemView positioned:CPViewHeightCentered | CPViewWidthCentered relativeTo:contentView withPadding:0.0];
        [contentView addSubview:title positioned:CPViewWidthCentered | CPViewTopAligned relativeTo:contentView withPadding:24.0];
        
        var contextHelp = [CPButton buttonWithTitle:@""];
        [contextHelp setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/context-help.png"]];
        [contextHelp setAlternateImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Images/context-help-pressed.png"]];
        [contextHelp setAutoresizingMask:CPViewMaxXMargin | CPViewMinYMargin];
        [contextHelp setBordered:NO];
        [contextHelp setFrameSize:CGSizeMake(26.0, 26.0)]
        [contentView addSubview:contextHelp positioned:CPViewLeftAligned | CPViewBottomAligned relativeTo:contentView withPadding:24.0];
        
        [lineItemViewBorder setCenter:[lineItemView center]];

    }
    return self;
}

- (void)sendEvent:(CPEvent)anEvent
{
    if([anEvent type] == CPKeyDown)
    {
        switch(anEvent._keyCode)
        {
            case 37: // key left
                [self left:self];
                [left setThemeState:CPThemeStateHighlighted];
                break;
            case 39: // key right
                [self right:self];
                [right setThemeState:CPThemeStateHighlighted];
                break;
            default:
                break;
        }
    
        if(([anEvent modifierFlags] & CPCommandKeyMask) && anEvent._keyCode == 13) // key enter
        {
            [close performClick:self];
        }
    }
    
    if([anEvent type] == CPKeyUp)
    {      
        switch(anEvent._keyCode)
        {
            case 37: // key left
                [left unsetThemeState:CPThemeStateHighlighted];
                break;
            case 39: // key right
                [right unsetThemeState:CPThemeStateHighlighted];
                break;
            default:
                break;
        }  
    }
    
    [super sendEvent:anEvent];
}

- (void)close:(id)sender
{
    if(delegate)
        [delegate saveLineItem];

    [self close];
    [self resignKeyWindow];
}

- (void)left:(id)sender
{
    if(delegate)
        [delegate previousLineItem];
}

- (void)right:(id)sender
{
    if(delegate)
        [delegate nextLineItem];
}

- (void)setTitle:(CPString)aTitle
{
    [title setStringValue:aTitle];
    [self _positionTitle];
}

- (void)setComment:(CPString)aComment
{
    [comment setStringValue:aComment];
}

- (void)setEnglishValue:(CPString)anEnglishValue
{
    [englishValue setStringValue:anEnglishValue];
}

- (void)setValue:(CPString)aValue
{
    [valueTextField setStringValue:aValue];
}

- (void)_positionTitle
{
    [title removeFromSuperview];
    [title sizeToFit];
    [[self contentView] addSubview:title positioned:CPViewWidthCentered | CPViewTopAligned relativeTo:[self contentView] withPadding:24.0];
}

- (void)_makeCommentsView:(CGRect)frame
{
    commentsView = [[CPView alloc] initWithFrame:CGRectInset(frame, 12.0, 12.0)];
    [commentsView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable | CPViewMinXMargin];
    
    var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([commentsView bounds]), CGRectGetHeight([commentsView bounds]) - 140.0)];
    [scrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [scrollView setAutohidesScrollers:YES];
    [scrollView setHasHorizontalScroller:NO];
    [commentsView addSubview:scrollView];
    
    var prototype = [[CPCollectionViewItem alloc] init];
    [prototype setView:[[OLCommentView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([scrollView bounds]), 80.0)]];
    
    collectionView = [[CPCollectionView alloc] initWithFrame:[scrollView bounds]];
    [collectionView setItemPrototype:prototype];
    [collectionView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [collectionView setMaxNumberOfColumns:1];
    [collectionView setVerticalMargin:10.0];
    [collectionView setMinItemSize:CPMakeSize(100.0, 80.0)];
    [collectionView setMaxItemSize:CPMakeSize(10000.0, 80.0)];
    [scrollView setDocumentView:collectionView];
    
    commentTextField = [[CPTextField alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth([commentsView bounds]) - 18.0, 80.0)];
    [commentTextField setEditable:YES];
	[commentTextField setBezeled:YES];
    [commentTextField setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
	[commentTextField setLineBreakMode:CPLineBreakByWordWrapping];
	[commentTextField setTarget:self];
	[commentTextField setAction:@selector(saveComment:)];
    [commentsView addSubview:commentTextField positioned:CPViewBelow | CPViewWidthCentered relativeTo:scrollView withPadding:12.0];
    
    var submitButton = [CPButton buttonWithTitle:@"Save Comment"];
    [submitButton setWidth:CGRectGetWidth([commentTextField bounds])];
    [submitButton setTarget:self];
    [submitButton setAction:@selector(saveComment:)]
    [submitButton setAutoresizingMask:CPViewWidthSizable | CPViewMinYMargin];
    [commentsView addSubview:submitButton positioned:CPViewBelow | CPViewWidthCentered relativeTo:commentTextField withPadding:12.0];
}

- (void)saveComment:(id)sender
{
    if(delegate)
        [delegate saveComment];
    
    [commentTextField setStringValue:@""];
}

- (void)setComments:(CPArray)comments
{
    [collectionView setContent:comments];
    [collectionView reloadContent];
}
    
@end
