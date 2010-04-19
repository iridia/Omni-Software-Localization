@import "../Models/OLResource.j"
@import <OJMoq/OJMoq.j>

var json = {"fileName":"Chess.app/Contents/Resources/English.lproj/InfoPlist.strings","fileType":"strings","dict":{"key":["","","",""],"string":["","","",""]},"comments_dict":{"key":["","","",""],"string":[" Localized versions of Info.plist keys ","","",""]}};

@implementation OLResourceTest : OJTestCase
{
    OLResource  resource;
    JSObject    params;
}

- (void)setUp
{
    params = {
        "fileName": "FileName",
        "fileType": "zip",
        "lineItems": [moq(), moq(), moq()]
    };
    
    resource = [[OLResource alloc] initWithFileName:params.fileName fileType:params.fileType lineItems:params.lineItems];
}

- (void)testThatOLResourceDoesCreateResourceFromJSON
{
    var target = [OLResource resourceFromJSON:json];
    
    [self assertNotNull:target];
    [self assert:json.fileName equals:[target fileName]];
    [self assert:json.fileType equals:[target fileType]];
}

- (void)testThatOLResourceDoesInitialize
{
    [self assertNotNull:resource];
}

- (void)testThatOLResourceDoesInitWithDefaultParameters
{
    [self assert:params.fileName equals:[resource fileName]];
    [self assert:params.fileType equals:[resource fileType]];
    [self assertTrue:[params.lineItems isEqualToArray:[resource lineItems]]];
}

- (void)testThatOLResourceDoesHaveZeroVotes
{
    [self assert:0 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveOneVoteAfterVoteUp
{    
    [resource voteUp:moq()];
    
    [self assert:1 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveTwoVotesAfterVoteUp
{
    [resource voteUp:moq()];
    [resource voteUp:moq()];

    [self assert:2 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveOneVoteAfterSameUserUpVotesTwice
{
    var user = moq();

    [resource voteUp:user];
    [resource voteUp:user];

    [self assert:1 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneVoteDownVote
{
    [resource voteDown:moq()];

    [self assert:-1 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeTwoVoteDownVote
{
    [resource voteDown:moq()];
    [resource voteDown:moq()];

    [self assert:-2 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneAfterSameUserDownVotesTwice
{
    var user = moq();

    [resource voteDown:user];
    [resource voteDown:user];

    [self assert:-1 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveNegativeOneAfterUpAndDownVoteBySameUser
{
    var user = moq();

    [resource voteUp:user];
    [resource voteDown:user];

    [self assert:-1 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesHaveZeroAfterUpAndDownVote
{
    [resource voteUp:moq()];
    [resource voteDown:moq()];

    [self assert:0 equals:[resource numberOfVotes]];
}

- (void)testThatOLResourceDoesClone
{
    var clone = [resource clone];
    
    [self assert:clone notSame:resource];
}

- (void)testThatOLResourceDoesCloneCorrectly
{
    var clone = [resource clone];

    [self assert:[clone fileName] equals:[resource fileName]];
    [self assert:[clone fileType] equals:[resource fileType]];
    [self assert:[[clone lineItems] count] equals:[[resource lineItems] count]];
}

- (void)testThatOLResourceDoesAddLineItems
{
    var lineItem = moq();
    
    [resource addLineItem:lineItem];
    
    [self assert:(params.lineItems.length + 1) equals:[[resource lineItems] count]];
    [self assert:lineItem equals:[[resource lineItems] objectAtIndex:(params.lineItems.length)]];
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

- (void)testThatOLResourceDoesGetShortFileName
{
    var target = [[OLResource alloc] initWithFileName:@"Resources/en.lproj/Menu.strings" fileType:@"strings" lineItems:[CPArray array]];
    
    [self assert:@"Menu.strings" equals:[target shortFileName]];
}

- (void)testThatOLResourceDoesInitializeWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:params.fileName arguments:[@"OLResourceFileNameKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:params.fileType arguments:[@"OLResourceFileTypeKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:params.lineItems arguments:[@"OLResourceLineItemsKey"]];
	
	var target = [[OLResource alloc] initWithCoder:coder];

	[self assert:params.fileName equals:[target fileName]];
	[self assert:params.fileType equals:[target fileType]];
	[self assert:params.lineItems equals:[target lineItems]];
}

- (void)testThatOLResourceDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[params.fileName, @"OLResourceFileNameKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[params.fileType, @"OLResourceFileTypeKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[params.lineItems, @"OLResourceLineItemsKey"]];
	
	var target = [[OLResource alloc] initWithFileName:params.fileName fileType:params.fileType lineItems:params.lineItems];
	[target encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end