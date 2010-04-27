@import <Foundation/CPObject.j>

@import "OLLineItem.j"

/*!
 * OLResource is a representation of a single resource. It is a member of a
 * set that could possibly belong to an OLBundle.
 */
@implementation OLResource : CPObject
{
	CPString		fileName	@accessors;
	CPString		fileType	@accessors(readonly);
	CPArray			lineItems   @accessors(readonly);
	CPDictionary   	votes;
}

+ (id)resourceFromJSON:(JSON)json
{
    var lineItems = [OLLineItem lineItemsFromJSON:json];
    
    return [[self alloc] initWithFileName:json.fileName fileType:json.fileType lineItems:lineItems]
}

- (id)init
{
	return [self initWithFileName:@"" fileType:@"" lineItems:[CPArray array]];
}

- (id)initWithFileName:(CPString)aFileName fileType:(CPString)aFileType lineItems:(CPArray)someLineItems
{
	if(self = [super init])
	{
		fileName = aFileName;
		fileType = aFileType;
		lineItems = [someLineItems copy];
		votes = [CPDictionary dictionary];
	}
	return self;
}

- (CPString)shortFileName
{
    return (/.*\/(.*)/).exec([self fileName])[1];
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
    [lineItems addObject:aLineItem];
}

- (OLResource)clone
{
    var clone = [[OLResource alloc] initWithFileName:[self fileName] fileType:[self fileType] lineItems:[CPArray array]];
    
    for(var i = 0; i < [lineItems count]; i++)
    {
        [clone addLineItem:[[lineItems objectAtIndex:i] clone]];
    }
    
    return clone;
}

- (CPArray)comments
{
    var result = [CPArray array];
    
    for(var i = 0; i < [lineItems count]; i++)
    {
        [result addObjectsFromArray:[[lineItems objectAtIndex:i] comments]];
    }
    
    return result;
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
        fileName = [aCoder decodeObjectForKey:OLResourceFileNameKey];
        fileType = [aCoder decodeObjectForKey:OLResourceFileTypeKey];
        lineItems = [aCoder decodeObjectForKey:OLResourceLineItemsKey];
		votes = [aCoder decodeObjectForKey:OLResourceVotesKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [aCoder encodeObject:[self fileName] forKey:OLResourceFileNameKey];
    [aCoder encodeObject:[self fileType] forKey:OLResourceFileTypeKey];
    [aCoder encodeObject:[self lineItems] forKey:OLResourceLineItemsKey];
	[aCoder encodeObject:votes forKey:OLResourceVotesKey];
}

@end
