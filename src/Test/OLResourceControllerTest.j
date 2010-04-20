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

// Cant test vote down for the same reason as above

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