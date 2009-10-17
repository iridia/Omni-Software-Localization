@import <Foundation/CPObject.j>

/*!
 * OLResource is a representation of a single resource. It is a member of a
 * set that could possibly belong to an OLBundle.
 */
@implementation OLResource : CPObject
{
	CPString	_fileName	@accessors(readonly, property=fileName);
	CPArray		_tags		@accessors(readonly, property=tags);
	CPString	_fileType	@accessors(readonly, property=fileType);
	CPArray		_lineItems  @accessors(readonly, property=lineItems);
}

- (id)initWithFilename:(CPString)fileName withTags:(CPArray)tags withFileType:(CPString)fileType withLineItems:(CPArray)someLineItems
{
	if(self = [super init])
	{
		_fileName = fileName;
		_tags = tags;
		_fileType = fileType;
		_lineItems = someLineItems;
	}
	return self;
}

@end
