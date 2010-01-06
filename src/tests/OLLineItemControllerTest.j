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

@end