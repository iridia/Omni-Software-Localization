
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
    if(_delegate && [_delegate respondsToSelector:@selector(nextLineItem:)])
    {
        [self setLineItem:[_delegate nextLineItem:_lineItem]];
    }
}

- (@action)previous:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(previousLineItem:)])
    {
        [self setLineItem:[_delegate previousLineItem:_lineItem]];
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
    if ([_delegate respondsToSelector:@selector(didEditResourceForEditingBundle)])
	{
        [_delegate didEditResourceForEditingBundle];
	}
}

@end
