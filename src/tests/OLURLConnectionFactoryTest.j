@import <OJMoq/OJMoq.j>
@import "../Utilities/OLURLConnectionFactory.j"

@implementation OLURLConnectionFactoryTest : OJTestCase
{
    OJMoq       urlConnection;
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
    [OLException setConnectionFactoryMethod:nil];
}

- (void)testThatOLActiveRecordDoesCreateConnectionWithUrlConnection
{
    var anObject = moq();
    [urlConnection selector:@selector(createConnectionWithRequest:delegate:) returns:anObject];
    [self assert:anObject equals:[OLURLConnectionFactory createConnectionWithRequest:moq() delegate:moq()]];
}

- (void)testThatOLActiveRecordDoesSetCreateConnectionFactoryMethod
{
    var anObject = moq();
    var factoryMethod = function(a, b) { return anObject; };
    [OLURLConnectionFactory setConnectionFactoryMethod:factoryMethod];
    
    [self assert:anObject equals:[OLURLConnectionFactory createConnectionWithRequest:moq() delegate:moq()]];
}

@end