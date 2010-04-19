@import "../Controllers/OLGlossaryController.j"
@import "../Controllers/OLContentViewController.j"

@implementation OLGlossaryControllerTest : OJTestCase

- (void)testThatOLGlossaryControllerDoesInitialize
{
    [self assertNotNull:[[OLGlossaryController alloc] init]];
}

- (void)testThatOLGlossaryControllerDoesLoadGlossaries
{
    var tempGlossary = OLGlossary;
    OLGlossary = moq();
    
    [OLGlossary selector:@selector(listWithCallback:) times:1];
    
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

- (void)testThatOLGlossaryControllerDoesSetSelectedGlossaryWhenReceivingOutlineViewSelection
{
    var notification = moq();
    var outlineView = moq();
    var item = moq();
    
    var target = [[OLGlossaryController alloc] init];
    
    [outlineView selector:@selector(itemAtRow:) returns:item];
    [outlineView selector:@selector(parentForItem:) returns:target];
    [outlineView selector:@selector(selectedRowIndexes) returns:moq()];
    [notification selector:@selector(object) returns:outlineView];
    [item selector:@selector(lineItems) returns:[CPArray array]];
    
    [target didReceiveOutlineViewSelectionDidChangeNotification:notification];
    
    [self assert:item equals:[target selectedGlossary]];
}

@end