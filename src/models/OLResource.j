@import <Foundation/CPObject.j>

/*!
 * OLResource is a representation of a single resource. It is a member of a
 * set that could possibly belong to an OLBundle.
 */
@implementation OLResource : CPObject
{
	CPString	_fileName	@accessors(readonly, property=fileName);
	CPString	_fileType	@accessors(readonly, property=fileType);
	CPArray		_lineItems  @accessors(readonly, property=lineItems);
}

- (id)initWithFilename:(CPString)fileName withFileType:(CPString)fileType withLineItems:(CPArray)someLineItems
{
	if(self = [super init])
	{
		_fileName = fileName;
		_fileType = fileType;
		_lineItems = someLineItems;
	}
	return self;
}

@end

var OLResourceFileNameKey = @"OLResourceFileNameKey";
var OLResourceFileTypeKey = @"OLResourceFileTypeKey";
var OLResourceLineItemsKey = @"OLResourceLineItemsKey";

@implementation OLResource (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _fileName = [aCoder decodeObjectForKey:OLResourceFileNameKey];
        _fileType = [aCoder decodeObjectForKey:OLResourceFileTypeKey];
        _lineItems = [aCoder decodeObjectForKey:OLResourceLineItemsKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_fileName forKey:OLResourceFileNameKey];
    [aCoder encodeObject:_fileType forKey:OLResourceFileTypeKey];
    [aCoder encodeObject:_lineItems forKey:OLResourceLineItemsKey];
}

@end
