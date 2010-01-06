@import "../Controllers/OLGlossaryController.j"

@implementation OLGlossaryControllerTest : OJTestCase

- (void)testThatOLGlossaryControllerDoesInitialize
{
    [self assertNotNull:[[OLGlossaryController alloc] init]];
}

- (void)testThatOLGlossaryControllerDoesLoadGlossaries
{
    var tempGlossary = OLGlossary;
    OLGlossary = moq();
    
    [OLGlossary expectSelector:@selector(listWithCallback:) times:1];
    
    var target = [[OLGlossaryController alloc] init];
    
    [target loadGlossaries];
    
    [OLGlossary verifyThatAllExpectationsHaveBeenMet];
    
    OLGlossary = tempGlossary;
}

- (void)testThatOLGlossaryControllerDoesAddGlossaries
{
    var glossary = moq();
    
    var target = [[OLGlossaryController alloc] init];
    
    [target insertObject:glossary inGlossariesAtIndex:0];
    
    [self assert:glossary equals:[[target glossaries] objectAtIndex:0]];
}

- (void)testThatOLGlossaryControllerDoesAddGlossariesViaAlternateMethod
{
    var glossary = moq();

    var target = [[OLGlossaryController alloc] init];

    [target addGlossary:glossary];

    [self assert:glossary equals:[[target glossaries] objectAtIndex:0]];
}

// TODO : Add more tests for the JSON handling stuff

@end