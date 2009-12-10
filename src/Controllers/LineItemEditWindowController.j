
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

- (void)setLineItem:(OLLineItem)aLineItem
{
    _lineItem = aLineItem;
    [[self window] setTitle:[aLineItem identifier]];
    [value setStringValue:[aLineItem value]];
}

- (void)controlTextDidEndEditing:(CPNotification)aNotification
{
    [_lineItem setValue:[value stringValue]];

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
