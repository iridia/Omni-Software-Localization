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
    [OLActiveRecord setConnectionFactoryMethod:function(a,b){return urlConnection;}];
}

- (void)tearDown
{
    [OLActiveRecord setConnectionFactoryMethod:nil];
}

- (void)testThatOLActiveRecordDoesCreateConnectionWithUrlConnection
{
    [self assert:urlConnection equals:[OLActiveRecord createConnectionWithRequest:moq() delegate:moq()]];
}

- (void)testThatOLActiveRecordDoesSetCreateConnectionFactoryMethod
{
    var anObject = moq();
    var factoryMethod = function(a, b) { return anObject; };
    [OLActiveRecord setConnectionFactoryMethod:factoryMethod];
    
    [self assert:anObject equals:[OLActiveRecord createConnectionWithRequest:moq() delegate:moq()]];
}

@end