@import <AppKit/CPView.j>

@implementation OLLineItemView : CPView
{
	CPTextField _lineItemIdentifierTextField;
	CPTextField _lineItemValueTextField;
	CPColor _unselectedBackgroundColor;
    CPImageView _arrow;
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
    
    if (!_arrow)
    {
        var arrowImage = [[CPImage alloc] initByReferencingFile:@"Resources/arrow.png" size:CGSizeMake(20,10)];
        _arrow = [[CPImageView alloc] initWithFrame:CGRectMake(0,0,20,10)];
        [_arrow setImage:arrowImage];
        
        [self addSubview:_arrow];
    }
    
    [_lineItemIdentifierTextField setStringValue:[anObject identifier]];
    [_lineItemIdentifierTextField setFont:[CPFont boldSystemFontOfSize:16]];
    [_lineItemIdentifierTextField sizeToFit];
    [_lineItemIdentifierTextField setCenter:CGPointMake([self center].x-(25+CGRectGetWidth([_lineItemIdentifierTextField bounds])/2), 21)];
    
    [_lineItemValueTextField setStringValue:[anObject value]];
    [_lineItemValueTextField setFont:[CPFont systemFontOfSize:16]];
    [_lineItemValueTextField sizeToFit];
    [_lineItemValueTextField setCenter:CGPointMake([self center].x+25+CGRectGetWidth([_lineItemValueTextField bounds])/2, 21)];
    
    [_arrow setCenter:CGPointMake([self center].x, 21)];
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
