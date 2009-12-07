
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
    if(self = [super initWithWindowCibPath:"Resources/"+aName owner:self])
    {
        [self setLineItem:[[OLLineItem alloc] initWithIdentifier:@"Test" value:@"value"]]
    }
    return self;
}

- (@action)done:(id)sender
{
    [[self window] close];
}

- (@action)next:(id)sender
{
    [[self window] setTitle:@"Next"];
}

- (@action)previous:(id)sender
{
    [[self window] setTitle:@"Previous"];
}

- (void)setLineItem:(OLLineItem)aLineItem
{
    _lineItem = aLineItem;
    [[self window] setTitle:[aLineItem identifier]];
    [value setStringValue:[aLineItem value]];
}

@end
