@import "../Models/OLResource.j"

var json = {"fileName":"Chess.app/Contents/Resources/English.lproj/InfoPlist.strings","fileType":"strings","dict":{"key":["","","",""],"string":["","","",""]},"comments_dict":{"key":["","","",""],"string":[" Localized versions of Info.plist keys ","","",""]}};

@implementation OLResourceTest : OJTestCase

- (void)testThatOLResourceDoesCreateResourceFromJSON
{
    var target = [OLResource resourceFromJSON:json];
    
    [self assertNotNull:target];
    [self assert:json.fileName equals:[target fileName]];
    [self assert:json.fileType equals:[target fileType]];
}

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
    [user selector:@selector(recordID) returns:"1"];

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
    [user selector:@selector(recordID) returns:"1"];

    [target voteDown:user];
    [target voteDown:user];

    [self assert:-1 equals:[target numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneAfterUpAndDownVoteBySameUser
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    var user = moq();
    [user selector:@selector(recordID) returns:"1"];

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

- (void)testThatOLResourceDoesClone
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    
    var clone = [target clone];
    
    [self assert:clone notSame:target];
}

- (void)testThatOLResourceDoesCloneFileName
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];

    var clone = [target clone];

    [self assertTrue:[[clone fileName] isEqualToString:[target fileName]]];
}

- (void)testThatOLResourceDoesCloneFileType
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];

    var clone = [target clone];

    [self assertTrue:[[clone fileType] isEqualToString:[target fileType]]];
}

- (void)testThatOLResourceDoesCloneLineItemArray
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[moq()]];

    var clone = [target clone];

    [self assert:[[clone lineItems] count] equals:[[target lineItems] count]];
}

- (void)testThatOLResourceDoesAddLineItems
{
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[CPArray array]];
    
    var lineItem = moq();
    
    [target addLineItem:lineItem];
    
    [self assert:1 equals:[[target lineItems] count]];
    [self assert:lineItem equals:[[target lineItems] objectAtIndex:0]];
}

- (void)testThatOLResourceDoesCloneLineItems
{
    var lineItem = moq();
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[lineItem]];
    
    var clonedLineItem = moq();
    [lineItem selector:@selector(clone) returns:clonedLineItem];

    var clone = [target clone];

    [self assert:clonedLineItem equals:[[clone lineItems] objectAtIndex:0]];
}

- (void)testThatOLResourceDoesHaveFileName
{
    var lineItem = moq();
    var target = [[OLResource alloc] initWithFileName:@"AFile" fileType:@"zip" lineItems:[lineItem]];
    
    [self assertSettersAndGettersFor:"fileName" on:target];
}

- (void)testThatOLResourceDoesGetShortFileName
{
    var target = [[OLResource alloc] initWithFileName:@"Resources/en.lproj/Menu.strings" fileType:@"strings" lineItems:[CPArray array]];
    
    [self assert:@"Menu.strings" equals:[target shortFileName]];
}

- (void)testThatOLResourceDoesHaveCommentsFromLineItems
{
    var lineItemOne = [[OLLineItem alloc] initWithIdentifier:@"Test1" value:@"1"];
    var lineItemTwo = [[OLLineItem alloc] initWithIdentifier:@"Test2" value:@"2"];
    
    [lineItemOne addComment:"joe"];
    [lineItemTwo addComment:"bob"];
    [lineItemTwo addComment:"test"];
    
    var target = [[OLResource alloc] initWithFileName:@"Resources/en.lproj/Menu.strings" fileType:@"strings" lineItems:[lineItemOne, lineItemTwo]];
    
    [self assert:3 equals:[[target comments] count]];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

@end