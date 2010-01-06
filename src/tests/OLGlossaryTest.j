@import "../Models/OLGlossary.j"

@implementation OLGlossaryTest : OJTestCase

- (void)testThatOLGlossaryDoesInitialize
{
    [self assertNotNull:[[OLGlossary alloc] initWithName:@"AGlossary"]];
}

- (void)testThatOLGlossaryDoesAddLineItems
{
    var glossary = [[OLGlossary alloc] initWithName:@"AGlossary"];
    [self assert:0 equals:[[glossary lineItems] count]];
    [glossary addLineItem:moq()];
    [self assert:1 equals:[[glossary lineItems] count]];
}

- (void)testThatOLGlossaryDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLGlossaryLineItemsKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLGlossaryNameKey"]];
    
    [self assertNotNull:[[OLGlossary alloc] initWithCoder:coder]];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLGlossaryDoesEncode
{
    var coder = moq();

//    Bug in OJMoq, will look into this later    
//    [coder expectSelector:@selector(encodeObject:forKey:) times:2];
    
    var glossary = [[OLGlossary alloc] initWithName:@"AGlossary"];
    
    [glossary encodeWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end