@import "../Models/OLLineItem.j"

var json = {"fileName":"Chess.app/Contents/Resources/English.lproj/InfoPlist.strings","fileType":"strings","dict":{"key":["","","",""],"string":["","","",""]},"comments_dict":{"key":["","","",""],"string":[" Localized versions of Info.plist keys ","","",""]}};

@implementation OLLineItemTest : OJTestCase

- (void)testThatOLLineItemDoesCreateFromJSON
{
    var target = [OLLineItem lineItemsFromJSON:json];

    [self assert:json.dict.key.length equals:[target count]];
}

- (void)testThatOLLineItemDoesInitialize
{
    var target = [[OLLineItem alloc] init];
    [self assertNotNull:target];
}

- (void)testThatOLLineItemDoesInitializeWithDefaultParameters
{
    [self assertNotNull:[[OLLineItem alloc] initWithIdentifier:@"id" value:@"value" comment:@"comment"]];
}

- (void)testThatOLLineItemDoesInitializeWithShortParameters
{
    [self assertNotNull:[[OLLineItem alloc] initWithIdentifier:@"id" value:@"value"]];
}

- (void)testThatOLLineItemDoesInitWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemCommentKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemIdentifierKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemValueKey"]];
    
    var target = [[OLLineItem alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}


- (void)testThatOLLineItemDoesCloneAndAreNotSame
{
    var target = [[OLLineItem alloc] init];
    var clone = [target clone];
    
    [self assert:clone notSame:target];
}


- (void)testThatOLLineItemDoesCloneIdentifier
{
    var identifier = "asdf";
    var target = [[OLLineItem alloc] initWithIdentifier:identifier value:@"" comment:@""];
    
    var clone = [target clone];
    
    [self assert:identifier equals:[clone identifier]];
}


- (void)testThatOLLineItemDoesCloneValue
{
    var value = "asdf";
    var target = [[OLLineItem alloc] initWithIdentifier:@"" value:value comment:@""];

    var clone = [target clone];

    [self assert:value equals:[clone value]];
}


- (void)testThatOLLineItemDoesCloneComment
{
    var comment = "asdf";
    var target = [[OLLineItem alloc] initWithIdentifier:@"" value:@"" comment:comment];

    var clone = [target clone];

    [self assert:comment equals:[clone comment]];
}

- (void)testThatLineItemDoesHaveValue
{
    var comment = "asdf";
    var target = [[OLLineItem alloc] initWithIdentifier:@"" value:@"" comment:comment];
    
    [self assertSettersAndGettersFor:"value" on:target];
}

- (void)testThatOLLineItemDoesAddComments
{
    var comment = "asdf";
    var target = [[OLLineItem alloc] initWithIdentifier:@"" value:@"" comment:comment];
    
    [target addComment:[[OLComment alloc] initFromUser:moq() withContent:"Test"]];
    
    [self assert:1 equals:[[target comments] count]];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}


@end