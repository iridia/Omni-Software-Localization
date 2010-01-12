@import <Foundation/CPCoder.j>

var OLJSONKeyedUnarchiverClassKey = @"$$CLASS$$";

@implementation OLJSONKeyedArchiver : CPCoder
{
    JSON    _json;
}

+ (JSON)archivedDataWithRootObject:(id)rootObject
{
    var json = {};
    var archiver = [[self alloc] initForWritingWithMutableData:json];
    
    [archiver startEncodingWithRootObject:rootObject];
    
    return json;
}

+ (BOOL)allowsKeyedCoding
{
    return YES;
}

- (id)initForWritingWithMutableData:(JSON)json
{
    if (self = [super init])
    {
        _json = json;
    }
    return self;
}

- (void)startEncodingWithRootObject:(id)rootObject
{
    [rootObject encodeWithCoder:self];
    _json[OLJSONKeyedUnarchiverClassKey] = CPStringFromClass([rootObject class]);
}

- (void)encodeObject:(id)anObject forKey:(CPString)aKey
{
    _json[aKey] = [self _encodeObject:anObject];
}

- (id)_encodeObject:(id)anObject
{
    var theType = typeof anObject;
    if (theType === "string" || theType === "number" || theType === "boolean")
    {
        return anObject;
    }
    else if (anObject === null)
    {
        return null;
    }
    else if ([anObject isKindOfClass:[CPArray class]])
    {
        var theObject = [];
        for (var i = 0; i < [anObject count]; i++)
        {
            theObject[i] = [self _encodeObject:[anObject objectAtIndex:i]];
        }
        return theObject;
    }
    else
    {
        return [[self class] archivedDataWithRootObject:anObject];
    }
}

- (void)encodeNumber:(int)aNumber forKey:(CPString)aKey
{
    _json[aKey] = aNumber;
}

- (void)_encodeDictionaryOfObjects:(CPDictionary)aDictionary forKey:(CPString)aKey
{
    var theObject = {};
    theObject[OLJSONKeyedUnarchiverClassKey] = CPStringFromClass([aDictionary class]);
    
    var keys = [aDictionary allKeys];
    for (var i = 0; i < [keys count]; i++)
    {
        theObject[keys[i]] = [self _encodeObject:[aDictionary objectForKey:keys[i]]];
    }
    return theObject;
}

@end
