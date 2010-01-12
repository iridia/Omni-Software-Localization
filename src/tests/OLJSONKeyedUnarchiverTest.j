@implementation OLJSONKeyedUnarchiverTest : OJTestCase

- (void)testThatOLJSONKeyedUnarchiverDoesInitialize
{
    [self assertNotNull:[[OLJSONKeyedUnarchiver alloc] initForReadingWithData:{}]];
}

- (void)testThatOLJSONKeyedUnarchiverDoesUnarchiveAString
{
    var data = @"Test";
    var response = [OLJSONKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self assert:data equals:response];
}

- (void)testThatOLJSONKeyedUnarchiverDoesUnarchiveMockObject
{
    var data = {"$$CLASS$$":"MockJSONParseObject","StringKey":"Bob","NumberKey":42,"BoolKey":true,"NullKey":null,"ArrayKey":["Bob",42,true,null],"DictionaryKey":{"$$CLASS$$":"CPDictionary","CP.objects":{"array":["Bob",42,true,null],"null":null,"bool":true,"number":42,"string":"Bob"}}};
    
    var response = [OLJSONKeyedUnarchiver unarchiveObjectWithData:data];

    [self assert:@"MockJSONParseObject" equals:CPStringFromClass([response class])];
    [self assert:data["StringKey"] equals:[response aString]];
    [self assert:data["NumberKey"] equals:[response aNumber]];
    [self assert:data["BoolKey"] equals:[response aBool]];
    [self assert:data["NullKey"] equals:[response aNull]];
    [self assert:data["ArrayKey"] equals:[response anArray]];
    [self assertTrue:[[CPDictionary dictionaryWithJSObject:data["DictionaryKey"]["CP.objects"]] isEqualToDictionary:[response aDictionary]]];
}

- (void)testThatOLJSONKeyedUnarchiverDoesUnarchiveMockObjectWithChild
{
    var data = {"$$CLASS$$":"MockJsonParseObjectWithChild","StringKey":"Bob","NumberKey":42,"BoolKey":true,"NullKey":null,"ArrayKey":["Bob",42,true,null],"DictionaryKey":{"$$CLASS$$":"CPDictionary","CP.objects":{"array":["Bob",42,true,null],"null":null,"bool":true,"number":42,"string":"Bob"}},"ChildKey":{"$$CLASS$$":"MockJSONParseObject","StringKey":"Bob","NumberKey":42,"BoolKey":true,"NullKey":null,"ArrayKey":["Bob",42,true,null],"DictionaryKey":{"$$CLASS$$":"CPDictionary","CP.objects":{"array":["Bob",42,true,null],"null":null,"bool":true,"number":42,"string":"Bob"}}}};
    
    var response = [OLJSONKeyedUnarchiver unarchiveObjectWithData:data];

    [self assert:@"MockJsonParseObjectWithChild" equals:CPStringFromClass([response class])];
    [self assert:data["StringKey"] equals:[response aString]];
    [self assert:data["NumberKey"] equals:[response aNumber]];
    [self assert:data["BoolKey"] equals:[response aBool]];
    [self assert:data["NullKey"] equals:[response aNull]];
    [self assert:data["ArrayKey"] equals:[response anArray]];
    [self assertTrue:[[CPDictionary dictionaryWithJSObject:data["DictionaryKey"]["CP.objects"]] isEqualToDictionary:[response aDictionary]]];
    [self assert:data["ChildKey"]["$$CLASS$$"] equals:CPStringFromClass([[response child] class])];
}

@end

@implementation MockJSONParseObject : CPObject
{
    CPString        aString     @accessors;
    int             aNumber     @accessors;
    BOOL            aBool       @accessors;
    id              aNull       @accessors;
    CPArray         anArray     @accessors;
    CPDictionary    aDictionary @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        aString = "Bob";
        aNumber = 42;
        aBool = YES;
        aNull = nil;
        anArray = [aString, aNumber, aBool, aNull];
        aDictionary = [CPDictionary dictionaryWithObjects:[aString, aNumber, aBool, aNull, anArray] forKeys:["string", "number", "bool", "null", "array"]];
    }
    return self;
}

- (id)initWithCoder:(CPCoder)coder
{
    self = [super init];
    if(self)
    {
        aString     = [coder decodeObjectForKey:@"StringKey"];
        aNumber     = [coder decodeObjectForKey:@"NumberKey"];
        aBool       = [coder decodeObjectForKey:@"BoolKey"];
        aNull       = [coder decodeObjectForKey:@"NullKey"];
        anArray     = [coder decodeObjectForKey:@"ArrayKey"];
        aDictionary = [coder decodeObjectForKey:@"DictionaryKey"];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)coder
{
    [coder encodeObject:aString forKey:@"StringKey"];
    [coder encodeObject:aNumber forKey:@"NumberKey"];
    [coder encodeObject:aBool forKey:@"BoolKey"];
    [coder encodeObject:aNull forKey:@"NullKey"];
    [coder encodeObject:anArray forKey:@"ArrayKey"];
    [coder encodeObject:aDictionary forKey:@"DictionaryKey"];
}

@end

@implementation MockJsonParseObjectWithChild : MockJSONParseObject
{
    MockJSONParseObject child   @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        child = [[MockJSONParseObject alloc] init];
    }
    return self;
}

- (id)initWithCoder:(CPCoder)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        child = [coder decodeObjectForKey:@"ChildKey"];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:child forKey:@"ChildKey"];
}

@end