@import "../Models/OLResource.j"

@implementation OLResourceTest : OJTestCase

- (void)testThatOLResourceDoesInitialize
{
    [self assertNotNull:[[OLResource alloc] init]];
}

- (void)testThatOLResourceDoesInitWithDefaultParameters
{
    [self assertNotNull:[[OLResource alloc] initWithFileName:@"AFile" fileType:"zip" lineItems:[CPArray array]]];
}

- (void)testThatOLResourceDoesHaveZeroVotes
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    
    [self assert:0 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveOneVoteAfterVoteUp
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    
    [target voteUp:moq()];
    
    [self assert:1 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveTwoVotesAfterVoteUp
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];

    [target voteUp:moq()];
    [target voteUp:moq()];

    [self assert:2 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveOneVoteAfterSameUserUpVotesTwice
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    var user = moq();

    [target voteUp:user];
    [target voteUp:user];

    [self assert:1 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneVoteDownVote
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];

    [target voteDown:moq()];

    [self assert:-1 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeTwoVoteDownVote
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];

    [target voteDown:moq()];
    [target voteDown:moq()];

    [self assert:-2 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneAfterSameUserDownVotesTwice
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    var user = moq();

    [target voteDown:user];
    [target voteDown:user];

    [self assert:-1 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneAfterUpAndDownVoteBySameUser
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    var user = moq();

    [target voteUp:user];
    [target voteDown:user];

    [self assert:-1 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveZeroAfterUpAndDownVote
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];

    [target voteUp:moq()];
    [target voteDown:moq()];

    [self assert:0 equals:[target numberOfVotes]];
}

@end