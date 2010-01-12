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
    
    return [archiver _encodeObject:rootObject];
    
    //return json;
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
        var json = {};
        var archiver = [[[self class] alloc] initForWritingWithMutableData:json];

        [anObject encodeWithCoder:archiver];
        json[OLJSONKeyedUnarchiverClassKey] = CPStringFromClass([anObject class]);

        return json;
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
