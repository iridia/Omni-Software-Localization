@import <OJMoq/OJMoq.j>
@import "../Models/OLMessage.j"

@implementation OLMessageTest : OJTestCase
{
    JSObject    testParams;
    OLMessage   message;
}

- (void)setUp
{
    var mockFromUser = moq();
    var mockToUser = moq();
    
    [mockFromUser selector:@selector(userIdentifier) returns:@"12345"];
    [mockFromUser selector:@selector(email) returns:@"email@email.com"];
    [mockToUser selector:@selector(userIdentifier) returns:@"54321"];
    
    testParams = {
        "subject": "Subject",
        "content": "Content",
        "toUsers": [mockToUser],
        "fromUser": mockFromUser
    };
    
    message = [[OLMessage alloc] initWithSender:testParams.fromUser receivers:testParams.toUsers subject:testParams.subject content:testParams.content];
}

- (void)testThatOLMessageDoesInitialize
{
    [self assertNotNull:[[OLMessage alloc] init]];
}

- (void)testThatOLMessageDoesInitializeWithDefaultParameters
{    
    [self assertNotNull:message];
    [self assert:[testParams.fromUser email] equals:[message senderEmail]];
    [self assertTrue:[testParams.toUsers isEqualToArray:[message receivers]]];
    [self assert:testParams.subject equals:[message subject]];
    [self assert:testParams.content equals:[message content]];
}

- (void)testThatOLMessageDoesInitWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.subject arguments:[@"OLMessageSubjectKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.content arguments:[@"OLMessageContentKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:[testParams.fromUser email] arguments:[@"OLMessageSenderEmailKey"]];
    [coder selector:@selector(decodeObjectForKey:) times:1 arguments:[@"OLMessageDateSentKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.toUsers arguments:[@"OLMessageReceiversKey"]];
    
    var target = [[OLMessage alloc] initWithCoder:coder];
    
    [self assert:testParams.subject equals:[target subject]];
    [self assert:testParams.content equals:[target content]];
    [self assert:[testParams.fromUser email] equals:[target senderEmail]];
    [self assertTrue:[testParams.toUsers isEqualToArray:[target receivers]]];

    [coder verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLMessageDoesHaveSubject
{
    var target = [[OLMessage alloc] init];
    
    [self assertSettersAndGettersFor:@"subject" on:target];
}

- (void)testThatOLMessageDoesHaveContent
{
    var target = [[OLMessage alloc] init];
    
    [self assertSettersAndGettersFor:@"content" on:target];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}


- (void)testThatOLMessageDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.subject, @"OLMessageSubjectKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.content, @"OLMessageContentKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.toUsers, @"OLMessageReceiversKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[[testParams.fromUser email], @"OLMessageSenderEmailKey"]];

	[message encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end