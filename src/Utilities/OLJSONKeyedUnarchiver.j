@import <Foundation/CPCoder.j>
@import <Foundation/CPDictionary.j>

var OLJSONKeyedUnarchiverClassKey = @"$$CLASS$$";

@implementation OLJSONKeyedUnarchiver : CPCoder
{
    JSON    _json;
}

+ (id)unarchiveObjectWithData:(JSON)json
{
    var unarchiver = [[self alloc] initForReadingWithData:json];
    return [unarchiver startDecodingWithRootData:json];
}

- (id)initForReadingWithData:(JSON)json
{
    if (self = [super init])
    {
        _json = json;
    }
    return self;
}

- (id)startDecodingWithRootData:(JSON)rootData
{
    var theClass = CPClassFromString(rootData[OLJSONKeyedUnarchiverClassKey]);
    var object = [[theClass alloc] initWithCoder:self];
    
    return object;
}

- (id)decodeObjectForKey:(CPString)aKey
{
    return [self _decodeObject:_json[aKey]];
}

- (id)_decodeObject:(id)anObject
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
    else if (anObject.constructor.toString().indexOf("Array") !== -1)
    {
        for (var i = 0; i < [anObject count]; i++)
        {
           anObject[i] = [self _decodeObject:[anObject objectAtIndex:i]];
        }
        return anObject;
    }
    else
    {
        return [[self class] unarchiveObjectWithData:anObject];
    }
}

- (id)_decodeDictionaryOfObjectsForKey:(CPString)aKey
{
    var theDictionary = [CPDictionary dictionary];

    for (var someKey in _json)
    {
        if (someKey !== OLJSONKeyedUnarchiverClassKey)
        {
            [theDictionary addObject:_json[someKey] forKey:someKey];
        }
    }
    
    return theDictionary;
}

@end
