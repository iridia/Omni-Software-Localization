@import "../Controllers/OLResourceController.j"

@implementation OLResourceControllerTest : OJTestCase

- (void)testThatOLResourceControllerDoesInitialize
{
    [self assertNotNull:[[OLResourceController alloc] init]];
}

- (void)testThatOLResourceControllerDoesVoteUp
{
    var resourceOne = moq([[OLResource alloc] init]);
    var resourceTwo = moq();
    var resourceThree = moq();
    
    var target = [[OLResourceController alloc] init];
    
    target.resources = [resourceOne, resourceTwo, resourceThree];
    [target setSelectedResource:resourceOne];
    
    [resourceOne selector:@selector(voteUp:) times:1];
    
    [target voteUp];
    
    [resourceOne verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesVoteDown
{
    var resourceOne = moq([[OLResource alloc] init]);
    var resourceTwo = moq();
    var resourceThree = moq();
    
    var target = [[OLResourceController alloc] init];
    
    target.resources = [resourceOne, resourceTwo, resourceThree];
    [target setSelectedResource:resourceOne];
    
    [resourceOne selector:@selector(voteDown:) times:1];
    
    [target voteDown];
    
    [resourceOne verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesGetNumberOfVotesFromResource
{
    var resourceOne = moq([[OLResource alloc] init]);
    var resourceTwo = moq();
    var resourceThree = moq();

    var target = [[OLResourceController alloc] init];

    target.resources = [resourceOne, resourceTwo, resourceThree];
    [target setSelectedResource:resourceOne];
    
    [resourceOne selector:@selector(numberOfVotes) times:1];
    [resourceOne selector:@selector(numberOfVotes) returns:5];
    
    [self assert:5 equals:[target numberOfVotesForSelectedResource]];
    
    [resourceOne verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesMoveToNextLineItem
{
    var lineItemController = moq([[OLLineItemController alloc] init]);
    
    var target = [[OLResourceController alloc] init];
    
    target.lineItemController = lineItemController;
    
    [lineItemController selector:@selector(nextLineItem) times:1];
    
    [target nextLineItem];
    
    [lineItemController verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesMoveToPreviousLineItem
{
    var lineItemController = moq([[OLLineItemController alloc] init]);
    
    var target = [[OLResourceController alloc] init];
    
    target.lineItemController = lineItemController;
    
    [lineItemController selector:@selector(previousLineItem) times:1];
    
    [target previousLineItem];
    
    [lineItemController verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesGetTitleOfTheSelectedResource
{
    var resourceOne = moq([[OLResource alloc] init]);
    var resourceTwo = moq();
    var resourceThree = moq();

    var target = [[OLResourceController alloc] init];

    target.resources = [resourceOne, resourceTwo, resourceThree];
    [target setSelectedResource:resourceOne];

    [resourceOne selector:@selector(shortFileName) times:1];
    [resourceOne selector:@selector(shortFileName) returns:@"Test"];

    [self assert:@"Test" equals:[target titleOfSelectedResource]];

    [resourceOne verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesSelectResourceAtIndex
{
    var resourceOne = moq([[OLResource alloc] init]);
    var resourceTwo = moq();
    var resourceThree = moq();

    var target = [[OLResourceController alloc] init];

    target.resources = [resourceOne, resourceTwo, resourceThree];
    [target setSelectedResource:resourceOne];
    
    [target selectResourceAtIndex:2];

    [self assert:resourceThree equals:[target selectedResource]];
}

- (void)testThatOLResourceControllerDoesSelectLineItemAtIndex
{
    var lineItemController = moq([[OLLineItemController alloc] init]);
    
    var target = [[OLResourceController alloc] init];
    
    target.lineItemController = lineItemController;
    
    [lineItemController selector:@selector(selectLineItemAtIndex:) times:1 arguments:[5]];
    
    [target selectLineItemAtIndex:5];
    
    [lineItemController verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesGetLineItemAtIndex
{
    var lineItemController = moq([[OLLineItemController alloc] init]);
    
    var target = [[OLResourceController alloc] init];
    
    target.lineItemController = lineItemController;
    
    var value = moq();
    
    [lineItemController selector:@selector(lineItemAtIndex:) times:1 arguments:[5]];
    [lineItemController selector:@selector(lineItemAtIndex:) returns:value arguments:[5]];
    
    [self assert:value equals:[target lineItemAtIndex:5]];
    
    [lineItemController verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLResourceControllerDoesGetValueForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(valueForSelectedLineItem)]
}

- (void)testThatOLResourceControllerDoesGetIdentifierForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(identifierForSelectedLineItem)]
}

- (void)testThatOLResourceControllerDoesGetCommentForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(commentForSelectedLineItem)]
}

- (void)testThatOLResourceControllerDoesGetCommentsForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(commentsForSelectedLineItem)]
}

- (void)testThatOLResourceControllerDoesGetAddCommentForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(addCommentForSelectedLineItem:)]
}

- (void)testThatOLResourceControllerDoesGetSetValueForSelectedLineItem
{
    [self assertGetFromSelectedLineItem:@selector(setValueForSelectedLineItem:)]
}

- (void)assertGetFromSelectedLineItem:(SEL)selector
{
    var lineItemController = moq([[OLLineItemController alloc] init]);

    var target = [[OLResourceController alloc] init];

    target.lineItemController = lineItemController;

    [lineItemController selector:selector times:1];

    [target performSelector:selector];

    [lineItemController verifyThatAllExpectationsHaveBeenMet];
}

@end