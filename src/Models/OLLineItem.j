@import "OLActiveRecord.j"
@import "OLComment.j"

@implementation OLLineItem : OLActiveRecord
{
	CPString    comment		@accessors(readonly);
	CPString    identifier 	@accessors(readonly);
	CPObject    value       @accessors;
	CPArray     comments    @accessors(readonly);
}

+ (CPArray)lineItemsFromJSON:(JSON)json
{
    var lineItems = [CPArray array];
    
	var lineItemKeys = json.dict.key;
	var lineItemStrings = json.dict.string;
	
	if(json.fileType == "strings")
	{
		var lineItemComments = json.comments_dict.string;

		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[lineItems addObject:[[self alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i] comment:lineItemComments[i]]];
		}	
	}
	else
	{
		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[lineItems addObject:[[self alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i]]];
		}
	}
	
	return lineItems;
}

- (id)initWithIdentifier:(CPString)anIdentifier value:(CPObject)aValue
{
	[self initWithIdentifier:anIdentifier value:aValue comment:@"No Comment"];
}

- (id)initWithIdentifier:(CPString)anIdentifier value:(CPObject)aValue comment:(CPString)aComment
{
	if(self = [super init])
	{
		comment = aComment;
		identifier = anIdentifier;
		value = aValue;
		comments = [CPArray array];
	}
	return self;
}

- (void)addComment:(OLComment)aComment
{
    [comments addObject:aComment];
}

- (OLLineItem)clone
{
    return [[OLLineItem alloc] initWithIdentifier:identifier value:value comment:comment];
}

@end

var OLLineItemCommentKey = @"OLLineItemCommentKey";
var OLLineItemIdentifierKey = @"OLLineItemIdentifierKey";
var OLLineItemValueKey = @"OLLineItemValueKey";
var OLLineItemCommentsKey = @"OLLineItemCommentsKey";

@implementation OLLineItem (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super init];
    
    if (self)
    {
		comment = [aCoder decodeObjectForKey:OLLineItemCommentKey];
        identifier = [aCoder decodeObjectForKey:OLLineItemIdentifierKey];
        value = [aCoder decodeObjectForKey:OLLineItemValueKey];
        comments = [aCoder decodeObjectForKey:OLLineItemCommentsKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
	[aCoder encodeObject:comment forKey:OLLineItemCommentKey];
    [aCoder encodeObject:identifier forKey:OLLineItemIdentifierKey];
    [aCoder encodeObject:value forKey:OLLineItemValueKey];
    [aCoder encodeObject:comments forKey:OLLineItemCommentsKey];
}

@end
