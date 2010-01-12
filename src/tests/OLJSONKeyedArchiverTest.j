@implementation OLJSONKeyedArchiverTest : OJTestCase

- (void)testThatOLJSONKeyedArchiverDoesInitialize
{
    [self assertNotNull:[[OLJSONKeyedArchiver alloc] initForWritingWithMutableData:nil]];
}

- (void)testThatOLJSONKeyedArchiverDoesInitializeAndReturnDataWhenDataIsString
{
    var data = @"Test";
    var response = [OLJSONKeyedArchiver archivedDataWithRootObject:data];
    
    [self assert:data equals:response];
}
// 
// - (void)testThatOLJSONKeyedArchiverDoesInitializeAndReturnDataWhenDataIsEmptyObject
// {
//     var data = [[CPObject alloc] init];
//     var response = [OLJSONKeyedArchiver archivedDataWithRootObject:data];
//     
//     [self assert:{__CLASS__:"CPObject"} equals:response];
// }

- (void)testThatOLJSONKeyedArchiverDoesInitializeAndReturnDataWhenGivenMockObject
{
    var data = [[MockJSONParseObject alloc] init];
    var response = [OLJSONKeyedArchiver archivedDataWithRootObject:data];
    
    [self assert:@"Bob" equals:response["DataKey"]];
    [self assert:@"MockJSONParseObject" equals:response["$$CLASS$$"]];
}

- (void)testThatOLJSONKeyedArchiverDoesInitializeAndReturnDataWhenGivenMockObjectWithChild
{
    var data = [[MockJsonParseObjectWithChild alloc] init];
    var response = [OLJSONKeyedArchiver archivedDataWithRootObject:data];
    
    [self assert:@"Bob" equals:response["DataKey"]];
    [self assert:@"MockJsonParseObjectWithChild" equals:response["$$CLASS$$"]];
    [self assert:@"MockJSONParseObject" equals:response["ChildKey"]["$$CLASS$$"]];
}

- (void)testThatOLJSONKeyedArchiverDoesAllowKeyedCoding
{
    [self assertTrue:[OLJSONKeyedArchiver allowsKeyedCoding]];
}

// - (void)testThatOLJSONKeyedArchiverDoesWorkWhenNotUsingClassMethod
// {
//     var data = [[MockJSONParseObject alloc] init];
//     var response = {};
//     var target = [[OLJSONKeyedArchiver alloc] initForWritingWithMutableData:response];
//     [target startEncodingWithRootObject:data];
// 
//     [self assert:@"Bob" equals:response["DataKey"]];
//     [self assert:@"MockJSONParseObject" equals:response["$$CLASS$$"]];
// }

@end


@implementation MockJSONParseObject : CPObject
{
    CPString data;
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
    MockJSONParseObject child;
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
