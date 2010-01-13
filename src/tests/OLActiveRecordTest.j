@import "../Models/OLActiveRecord.j"
@import <AppKit/AppKit.j>
@import <OJMoq/OJMoq.j>

@implementation OLActiveRecordTest : OJTestCase
{
    OJMoq urlConnection;
}

- (void)setUp
{
    urlConnection = moq();
    [OLActiveRecord setConnectionFactoryMethod:function(request, delegate)
    {
        return [urlConnection createConnectionWithRequest:request delegate:delegate];
    }];
}

- (void)tearDown
{
    [OLActiveRecord setConnectionFactoryMethod:nil];
}

- (void)testThatOLActiveRecordDoesCreateConnectionWithUrlConnection
{
    var anObject = moq();
    [urlConnection selector:@selector(createConnectionWithRequest:delegate:) returns:anObject];
    [self assert:anObject equals:[OLActiveRecord createConnectionWithRequest:moq() delegate:moq()]];
}

- (void)testThatOLActiveRecordDoesSetCreateConnectionFactoryMethod
{
    var anObject = moq();
    var factoryMethod = function(a, b) { return anObject; };
    [OLActiveRecord setConnectionFactoryMethod:factoryMethod];
    
    [self assert:anObject equals:[OLActiveRecord createConnectionWithRequest:moq() delegate:moq()]];
}

- (void)testThatOLActiveRecordDoesFindByName
{
    [urlConnection expectSelector:@selector(createConnectionWithRequest:delegate:) times:1];
    
    [OLActiveRecord find:@"name" by:@"joe" callback:function(){}];
    
    [urlConnection verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLActiveRecordDoesGetWithCallback
{
    [urlConnection expectSelector:@selector(createConnectionWithRequest:delegate:) times:1];
    
    [[[OLActiveRecord alloc] init] getWithCallback:function(){}];
    
    [urlConnection verifyThatAllExpectationsHaveBeenMet];
}

@end