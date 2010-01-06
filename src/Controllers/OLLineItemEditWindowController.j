
@import <Foundation/CPObject.j>

@implementation OLLineItemEditWindowController : CPWindowController
{
    @outlet CPTextField comment;
    @outlet CPTextField value;
    id _delegate @accessors(property=delegate);
    OLLineItem _lineItem;
}

- (id)initWithWindowCibName:(CPString)aName
{
	[value setTarget:self];
	[value setAction:@selector(done:)]
    return [self initWithWindowCibName:aName lineItem:[[OLLineItem alloc] 
        initWithIdentifier:@"Error" value:@"There was an error in the code."]];
}

- (id)initWithWindowCibName:(CPString)aName lineItem:(OLLineItem)aLineItem
{
    if(self = [super initWithWindowCibPath:"Resources/"+aName owner:self])
    {
        [self setLineItem:aLineItem];
    }
    return self;
}

- (void)awakeFromCib
{
	[comment setLineBreakMode:CPLineBreakByWordWrapping];
	[value setLineBreakMode:CPLineBreakByWordWrapping];
	
    [[CPApplication sharedApplication] runModalForWindow:[self window]];
}

- (@action)done:(id)sender
{
    [[self window] close];
}

- (@action)next:(id)sender
{
    if([_delegate respondsToSelector:@selector(nextLineItem)])
    {
        [_delegate nextLineItem];
    }
}

- (@action)previous:(id)sender
{
    if([_delegate respondsToSelector:@selector(previousLineItem)])
    {
        [_delegate previousLineItem];
    }
}

- (void)windowWillClose:(id)window
{
	[[CPApplication sharedApplication] stopModal];
}

- (void)setLineItem:(OLLineItem)aLineItem
{
    _lineItem = aLineItem;
    [[self window] setTitle:[aLineItem identifier]];
    [value setStringValue:[aLineItem value]];
	[comment setStringValue:[aLineItem comment]];
}

- (void)controlTextDidChange:(CPNotification)aNotification
{
    [_lineItem setValue:[value stringValue]];
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
        object:_lineItem];
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
