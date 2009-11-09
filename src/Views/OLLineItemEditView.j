@import <AppKit/CPView.j>

/*!
 * The OLLineItemEditView is the view for editing line
 * items.
 */
@implementation OLLineItemEditView : CPView
{
	CPTextField _editBox;
	CPObject _delegate @accessors(property=delegate);
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		_editBox = [CPTextField roundedTextFieldWithStringValue:@"" placeholder:@"" width:CGRectGetWidth([self bounds])];
		[_editBox setDelegate:self];
		[self addSubview:_editBox];
	}
	return self;
}

- (void)setContent:(OLLineItem)aLineItem
{
	[_editBox setStringValue:[aLineItem value]];
	_currentLineItem = aLineItem;
	
	if(_delegate)
	{
		[[CPNotificationCenter defaultCenter]
             addObserver:_delegate
                selector:@selector(controlTextDidChange:)
                    name:CPControlTextDidChangeNotification
                  object:self];
	}
}

- (void)controlTextDidChange:(CPNotification)aNotification
{
	[_currentLineItem setValue:[[aNotification object] stringValue]];
	
    [[CPNotificationCenter defaultCenter] postNotificationName:CPControlTextDidChangeNotification object:self userInfo:[CPDictionary dictionary]];
}

@end
