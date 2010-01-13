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
    [OLActiveRecord setConnectionBuilderMethod:function(a,b){return urlConnection;}];
}

- (void)tearDown
{
    [OLActiveRecord setConnectionBuilderMethod:nil];
}

- (void)testThatOLActiveRecordDoesCreateConnectionWithUrlConnection
{
    [self assert:urlConnection equals:[OLActiveRecord createConnectionWithRequest:moq() delegate:moq()]];
}

@end