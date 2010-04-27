@import "../Controllers/OLLineItemController.j"

@implementation OLLineItemControllerTest : OJTestCase

- (void)testThatOLLineItemControllerDoesInitialize
{
    [self assertNotNull:[[OLLineItemController alloc] init]];
}

- (void)testThatOLLineItemControllerDoesReturnNextLineItem
{
    var lineItemOne = moq();
    var lineItemTwo = moq();
    var lineItemThree = moq();
    
    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];
    
    var target = [[OLLineItemController alloc] init];
    
    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemTwo];
    [target nextLineItem];
    
    [self assert:lineItemThree equals:[target selectedLineItem]];
}

- (void)testThatOLLineItemControllerDoesReturnPreviousLineItem
{
    var lineItemOne = moq();
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemTwo];
    [target previousLineItem];

    [self assert:lineItemOne equals:[target selectedLineItem]];
}

- (void)testThatOLLineItemControllerDoesReturnPreviousLineItemOnWrap
{
    var lineItemOne = moq();
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemOne];
    [target previousLineItem];

    [self assert:lineItemThree equals:[target selectedLineItem]];
}

- (void)testThatOLLineItemControllerDoesReturnNextLineItemOnWrap
{
    var lineItemOne = moq();
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemThree];
    [target nextLineItem];

    [self assert:lineItemOne equals:[target selectedLineItem]];
}

- (void)testThatOLLineItemControllerDoesGetLineItemAtIndex
{
    var lineItemOne = moq();
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;

    [self assert:lineItemTwo equals:[target lineItemAtIndex:1]];
}

- (void)testThatOLLineItemControllerDoesGetValueForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(value)]
}

- (void)testThatOLLineItemControllerDoesGetIdentifierForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(identifier)]
}

- (void)testThatOLLineItemControllerDoesGetCommentForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(comment)]
}

- (void)testThatOLLineItemControllerDoesGetCommentsForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(comments)]
}

- (void)testThatOLLineItemControllerDoesAddCommentForSelectedLineItem
{
    var lineItemOne = moq([[OLLineItem alloc] initWithIdentifier:"test" value:"test"]);
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemOne];
    
    [lineItemOne selector:@selector(addComment:) times:1];
    
    [target addCommentForSelectedLineItem:[[OLComment alloc] init]];
    
    [lineItemOne verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLLineItemControllerDoesSetValueForSelectedLineItem
{
    var lineItemOne = moq([[OLLineItem alloc] initWithIdentifier:"test" value:"test"]);
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemOne];

    [lineItemOne selector:@selector(setValue:) times:1 arguments:["another"]];
    
    [target setValueForSelectedLineItem:"another"];
    
    [lineItemOne verifyThatAllExpectationsHaveBeenMet];
}

- (void)assertGetFromSelectedLineItem:(SEL)selector
{
    var lineItemOne = moq();
    var lineItemTwo = moq();
    var lineItemThree = moq();

    var lineItems = [lineItemOne, lineItemTwo, lineItemThree];

    var target = [[OLLineItemController alloc] init];

    target.lineItems = lineItems;
    [target setSelectedLineItem:lineItemOne];

    [lineItemOne selector:selector times:1];
    [lineItemOne selector:selector returns:@"Test"];

    [self assert:@"Test" equals:[target performSelector:selector+"ForSelectedLineItem"]];

    [lineItemOne verifyThatAllExpectationsHaveBeenMet];
}

@end