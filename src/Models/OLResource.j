@import "OLActiveRecord.j"

@import "OLLineItem.j"

/*!
 * OLResource is a representation of a single resource. It is a member of a
 * set that could possibly belong to an OLBundle.
 */
@implementation OLResource : OLActiveRecord
{
	CPString		_fileName	@accessors(readonly, property=fileName);
	CPString		_fileType	@accessors(readonly, property=fileType);
	CPArray			_lineItems  @accessors(readonly, property=lineItems);
	CPDictionary   	votes		@accessors(readonly);
}

+ (id)resourceFromJSON:(JSON)json
{
    var lineItems = [OLLineItem lineItemsFromJSON:json];
    
    return [[self alloc] initWithFileName:json.fileName fileType:json.fileType lineItems:lineItems]
}

// Overriding default initializer of superclass
- (id)init
{
	return [self initWithFileName:@"" fileType:@"" lineItems:[CPArray array]];
}

- (id)initWithFileName:(CPString)fileName fileType:(CPString)fileType lineItems:(CPArray)someLineItems
{
	if(self = [super init])
	{
		_fileName = fileName;
		_fileType = fileType;
		_lineItems = someLineItems;
		votes = [CPDictionary dictionary];
	}
	return self;
}

- (void)voteUp:(OLUser)user
{
    if (user)
    {
        [votes setObject:1 forKey:[user recordID]];
    }
}

- (void)voteDown:(OLUser)user
{
    if (user)
    {
        [votes setObject:-1 forKey:[user recordID]];
    }
}

- (int)numberOfVotes
{
    var users = [votes allKeys];
    
    var numVotes = 0;
    
    for (var i = 0; i < [users count]; i++)
    {
        numVotes += [votes objectForKey:[users objectAtIndex:i]];
    }

    return numVotes;
}

- (void)addLineItem:(OLLineItem)aLineItem
{
    [_lineItems addObject:aLineItem];
}

- (OLResource)clone
{
    var clone = [[OLResource alloc] initWithFileName:_fileName fileType:_fileType lineItems:[CPArray array]];
    
    for(var i = 0; i < [_lineItems count]; i++)
    {
        [clone addLineItem:[[_lineItems objectAtIndex:i] clone]];
    }
    
    return clone;
}

@end


var OLResourceFileNameKey = @"OLResourceFileNameKey";
var OLResourceFileTypeKey = @"OLResourceFileTypeKey";
var OLResourceLineItemsKey = @"OLResourceLineItemsKey";
var OLResourceVotesKey = @"OLResourceVotesKey";

@implementation OLResource (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
        _fileName = [aCoder decodeObjectForKey:OLResourceFileNameKey];
        _fileType = [aCoder decodeObjectForKey:OLResourceFileTypeKey];
        _lineItems = [aCoder decodeObjectForKey:OLResourceLineItemsKey];
		votes = [aCoder decodeObjectForKey:OLResourceVotesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:_fileName forKey:OLResourceFileNameKey];
    [aCoder encodeObject:_fileType forKey:OLResourceFileTypeKey];
    [aCoder encodeObject:_lineItems forKey:OLResourceLineItemsKey];
	[aCoder encodeObject:votes forKey:OLResourceVotesKey];
}

@end
