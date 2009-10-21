@import <AppKit/CPView.j>

@implementation OLLineItemView : CPView
{
	CPTextField _lineItemIdentifierTextField;
	CPTextField _lineItemValueTextField;
	CPColor _unselectedBackgroundColor;
}

- (void)setRepresentedObject:(OLLineItem)anObject
{
    if (!_unselectedBackgroundColor)
    {
    	_unselectedBackgroundColor = [CPColor colorWithCalibratedWhite:0.926 alpha:1.0];
    	[self setBackgroundColor:_unselectedBackgroundColor];
    }
    
    if(!_lineItemIdentifierTextField)
    {
    	_lineItemIdentifierTextField = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
		[self addSubview:_lineItemIdentifierTextField];
    }
    
    if (!_lineItemValueTextField)
    {
    	_lineItemValueTextField = [[CPTextField alloc] initWithFrame:CGRectMakeZero()];
    	[self addSubview:_lineItemValueTextField];
    }
    
    [_lineItemIdentifierTextField setStringValue:[anObject identifier]];
    [_lineItemIdentifierTextField sizeToFit];
    [_lineItemIdentifierTextField setCenter:CGPointMake([self center].x, 14)];
    
    [_lineItemValueTextField setStringValue:[anObject value]];
    [_lineItemValueTextField sizeToFit];
    [_lineItemValueTextField setCenter:CGPointMake([self center].x, 28)];
    
}

- (void)setSelected:(BOOL)isSelected
{
	if(isSelected)
	{
		[self setBackgroundColor:[CPColor colorWithHexString:@"CCCCFF"]];
	}
	else
	{
		[self setBackgroundColor:_unselectedBackgroundColor];
	}
	
}

@end