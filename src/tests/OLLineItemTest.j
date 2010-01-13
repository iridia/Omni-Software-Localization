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
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemCommentKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemIdentifierKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLLineItemValueKey"]];
    
    var target = [[OLLineItem alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

@end