@import "../Models/OLGlossary.j"
@import <OJMoq/OJMoq.j>

@implementation OLGlossaryTest : OJTestCase
{
    JSObject testParams;
    OLGlossary  target;
}

- (void)setUp
{
    testParams = {
        "name": "A Glossary",
        "lineItems": ["one", "two", "three"]
    };
    
    target = [[OLGlossary alloc] initWithName:testParams.name];
}

- (void)testThatOLGlossaryDoesInitialize
{
    [self assertNotNull:target];
    [self assert:testParams.name equals:[target name]];
}

- (void)testThatOLGlossaryDoesAddLineItems
{
    [self assert:0 equals:[[target lineItems] count]];
    [target addLineItem:moq()];
    [self assert:1 equals:[[target lineItems] count]];
}

- (void)testThatOLGlossaryDoesInitWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.name arguments:[@"OLGlossaryNameKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.lineItems arguments:[@"OLGlossaryLineItemsKey"]];
	
	var glossary = [[OLGlossary alloc] initWithCoder:coder];

	[self assert:testParams.name equals:[glossary name]];
	[self assert:testParams.lineItems equals:[glossary lineItems]];
}

- (void)testThatOLGlossaryDoesEncode
{
    var coder = moq();
	
    [coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.name, @"OLGlossaryNameKey"]];
    [coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.lineItems, @"OLGlossaryLineItemsKey"]];
	
	var glossary = [[OLGlossary alloc] initWithName:testParams.name];
	
	for (var i = 0; i < testParams.lineItems.length; i++) {
	    [glossary addLineItem:testParams.lineItems[i]];
	}
	
	[glossary encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end