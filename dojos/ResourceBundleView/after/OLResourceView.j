@import <AppKit/CPView.j>

@implementation OLResourceView : CPView
{
	CPTextField _fileNameTextField;
	CPColor _unselectedBackgroundColor;
}

- (void)setRepresentedObject:(OLResource)anObject
{
	if(!_unselectedBackgroundColor)
	{
		_unselectedBackgroundColor = [CPColor colorWithCalibratedWhite:0.926 alpha:1.000];
		[self setBackgroundColor:_unselectedBackgroundColor];
	}
	
    if(!_fileNameTextField)
    {
    	_fileNameTextField = [[CPTextField alloc] initWithFrame:[self bounds]];
    	[self addSubview:_fileNameTextField];
    }
    
        
	[_fileNameTextField setStringValue:[anObject fileName]];
    [_fileNameTextField sizeToFit];
    [_fileNameTextField setCenter:CGPointMake([self center].x, 21)];
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