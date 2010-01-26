@import "../Models/OLActiveRecord.j"
@import <AppKit/AppKit.j>
@import <OJMoq/OJMoq.j>
@import "../Utilities/OLURLConnectionFactory.j"

@implementation OLActiveRecordTest : OJTestCase
{
    OJMoq urlConnection;
}

- (void)setUp
{
    urlConnection = moq();
    [OLURLConnectionFactory setConnectionFactoryMethod:function(request, delegate)
    {
        return [urlConnection createConnectionWithRequest:request delegate:delegate];
    }];
}

- (void)tearDown
{
    [OLURLConnectionFactory setConnectionFactoryMethod:nil];
}

- (void)testThatOLActiveRecordDoesFindByName
{
    
    var tempCPURLConnection = CPURLConnection;
    try
    {
        [urlConnection selectorelector:@selector(createConnectionWithRequest:delegate:) times:2];

        CPURLConnection = moq();
        [CPURLConnection selector:@selector(sendSynchronousRequest:returningResponse:error:) returns:{"string":"{'rows':[{'id':1}, {'id':2}]}"}]
        [OLActiveRecord listWithCallback:function(){}];

        [urlConnection verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        CPURLConnection = tempCPURLConnection;
    }
}

- (void)testThatOLActiveRecordDoesFindByRecordID
{
    [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:1];
    
    [OLActiveRecord findByRecordID:@"123" withCallback:function(){}];

    [urlConnection verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLActiveRecordDoesGetWithCallback
{
    [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:1];
    
    [[[OLActiveRecord alloc] init] getWithCallback:function(){}];
    
    [urlConnection verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLActiveRecordDoesSave
{
    var tempOLJSONKeyedArchiver = OLJSONKeyedArchiver;
    try
    {
        OLJSONKeyedArchiver = moq();
        [OLJSONKeyedArchiver selector:@selector(archivedDataWithRootObject:) returns:@"asdf"];
    
        [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:1];

        var target = [[OLActiveRecord alloc] init];
        [target setRecordID:@"asdf"];
        [target save];

        [urlConnection verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        OLJSONKeyedArchiver = tempOLJSONKeyedArchiver;
    }
}

- (void)testThatOLActiveRecordDoesCreate
{
    var tempOLJSONKeyedArchiver = OLJSONKeyedArchiver;
    try
    {
        OLJSONKeyedArchiver = moq();
        [OLJSONKeyedArchiver selector:@selector(archivedDataWithRootObject:) returns:@"asdf"];

        [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:1];

        var target = [[OLActiveRecord alloc] init];
        [target save];

        [urlConnection verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        OLJSONKeyedArchiver = tempOLJSONKeyedArchiver;
    }
}

- (void)testThatOLActiveRecordDoesDelete
{
    [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:1];

    [[[OLActiveRecord alloc] init] delete];

    [urlConnection verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLActiveRecordDoesReturnAPIWithRecordID
{
    var target = [[OLActiveRecord alloc] init];
    [target setRecordID:@"asdf"];
    var result = [target apiURLWithRecordID:YES];
    
    [self assertTrue:@"api/activerecord/asdf" == result];
}

- (void)testThatOLActiveRecordDoesReturnAPI
{
    var target = [[OLActiveRecord alloc] init];
    var result = [target apiURLWithRecordID:NO];

    [self assertTrue:@"api/activerecord" == result];
}

- (void)testThatOLActiveRecordDoesListWithCallbackWithNoData
{
    var tempCPURLConnection = CPURLConnection;
    try
    {
        wasCalled = false;
        
        CPURLConnection = moq();
        [CPURLConnection selector:@selector(sendSynchronousRequest:returningResponse:error:) returns:{"string":"{'rows':[]}"}]
        [OLActiveRecord listWithCallback:function(){} finalCallback:function(){wasCalled=true;}];
        
        [self assertTrue:wasCalled];
    }
    finally
    {
        CPURLConnection = tempCPURLConnection;
    }
}

- (void)testThatOLActiveRecordDoesListWithCallbackWithData
{
    var tempCPURLConnection = CPURLConnection;
    try
    {
        [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:2];

        CPURLConnection = moq();
        [CPURLConnection selector:@selector(sendSynchronousRequest:returningResponse:error:) returns:{"string":"{'rows':[{'id':1}, {'id':2}]}"}]
        [OLActiveRecord listWithCallback:function(){}];

        [urlConnection verifyThatAllExpectationsHaveBeenMet];
    }
    finally
    {
        CPURLConnection = tempCPURLConnection;
    }
}

- (void)testThatOLActiveRecordDoesFindAllByCallback
{
    [urlConnection selector:@selector(createConnectionWithRequest:delegate:) times:1];
    
    [OLActiveRecord findAllBy:@"name" withCallback:function(){}];

    [urlConnection verifyThatAllExpectationsHaveBeenMet];
}

@end