@import "../Controllers/OLResourceController.j"

@implementation OLResourceControllerTest : OJTestCase

- (void)testThatOLResourceControllerDoesInitialize
{
    [self assertNotNull:[[OLResourceController alloc] init]];
}

// Cant test vote up because we cant test callbacks
// - (void)testThatOLResourceControllerDoesVoteUp
// {
//     var tempUser = OLUser;
//     
//     OLUser = moq();
//     
//     var selectedResource = moq();
//     var resourceView = moq();
//     
//     [OLUser expectSelector:@selector(findByRecordId:withCallback:) times:1];
//     [selectedResource expectSelector:@selector(voteUp:) times:1];
//     [resourceView expectSelector:@selector(setVoteCount:) times:1];
//     
//     var target = [[OLResourceController alloc] init];
//     
//     [target voteUp:moq()];
//     
//     [OLUser verifyThatAllExpectationsHaveBeenMet];
//     [selectedResources verifyThatAllExpectationsHaveBeenMet];
//     [resourceView verifyThatAllExpectationsHaveBeenMet];
// }

// Cant test vote down for the same reason as above

@end