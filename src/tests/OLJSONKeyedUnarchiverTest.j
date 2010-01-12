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

- (void)testThatOLJSONKeyedUnarchiverDoesUnarchiveAnObject
{
    var data = {"$$CLASS$$":"CPObject"};
    var response = [OLJSONKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self assert:"CPObject" equals:CPStringFromClass([response class])];
}

- (void)testThatOLJSONKeyedUnarchiverDoesUnarchiveMockObject
{
    var data = {"DataKey":@"bob", "$$CLASS$$":"MockJSONParseObject"};
    var response = [OLJSONKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self assert:"MockJSONParseObject" equals:CPStringFromClass([response class])];
    [self assert:"bob" equals:[response data]];
}

- (void)testThatOLJSONKeyedUnarchiverDoesUnarchiveMockObjectWithChild
{
    var data = {"DataKey":@"bob", "$$CLASS$$":"MockJsonParseObjectWithChild", "ChildKey":{"DataKey":"joe","$$CLASS$$":"MockJSONParseObject"}};
    var response = [OLJSONKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self assert:"MockJsonParseObjectWithChild" equals:CPStringFromClass([response class])];
    [self assert:"bob" equals:[response data]];
    [self assert:"joe" equals:[[response child] data]];
}

@end

@implementation MockJSONParseObject : CPObject
{
    CPString data @accessors;
}

- (id)init
{
    if(self = [super init])
    {
        data = "Bob";
    }
    return self;
}

- (id)initWithCoder:(CPCoder)coder
{
    self = [super init];
    if(self)
    {
        data = [coder decodeObjectForKey:@"DataKey"];
    }
    return self;
}

- (void)encodeWithCoder:(CPCoder)coder
{
    [coder encodeObject:data forKey:@"DataKey"];
}

@end

@implementation MockJsonParseObjectWithChild : MockJSONParseObject
{
    MockJSONParseObject child @accessors;
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