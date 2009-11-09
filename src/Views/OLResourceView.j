@import <AppKit/CPView.j>

@implementation OLResourceView : CPView
{
	CPTextField _fileNameTextField;
	CPColor _unselectedBackgroundColor;
	CPImageView _xmlIcon;
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
    
    if (!_xmlIcon)
    {
        var xmlImage = [[CPImage alloc] initByReferencingFile:@"Resources/xml.png" size:CGSizeMake(30,12)];
        _xmlIcon = [[CPImageView alloc] initWithFrame:CGRectMake(0,0,30,12)];
        [_xmlIcon setImage:xmlImage];
        [_xmlIcon setBackgroundColor:[CPColor blueColor]];
        
        [self addSubview:_xmlIcon];
    }
    
    
	[_fileNameTextField setStringValue:[anObject fileName]];
	[_fileNameTextField setFont:[CPFont boldSystemFontOfSize:16]];
    [_fileNameTextField sizeToFit];
    [_fileNameTextField setCenter:CGPointMake([self center].x-50+CGRectGetWidth([_fileNameTextField bounds])/2, 21)];
    
    [_xmlIcon setCenter:CGPointMake([self center].x-70, 21)];
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
