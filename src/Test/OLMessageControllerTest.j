@implementation OLMessageControllerTest : OJTestCase

- (void)testThatOLMessageControllerDoesInitialize
{
    [self assertNotNull:[[OLMessageController alloc] init]];
}

- (void)testThatOLMessageControllerDoesCreateBroadcastMessage
{
    var target = [[OLMessageController alloc] init];
    var notification = [[CPNotification alloc] initWithName:@"Test" object:moq() userInfo:moq()];
    
    [target createBroadcastMessage:notification];
    
    [self assertTrue:[target.messageWindow.emailLabel isHidden]];
}

- (void)testThatOLMessageControllerDoesCreateMessage
{
    var target = [[OLMessageController alloc] init];
    var notification = [[CPNotification alloc] initWithName:@"Test" object:moq() userInfo:moq()];
    
    [target createMessage:notification];
    
    [self assertFalse:[target.messageWindow.emailLabel isHidden]];
}

- (void)testThatOLMessageControllerDoesLoadMessages
{
    var OGMessage = OLMessage;
    
    try {
        OLMessage = moq();
        
        [OLMessage selector:@selector(findByToUsers:withCallback:) times:1];
        [[OLUserSessionManager defaultSessionManager] setStatus:OLUserSessionLoggedInStatus];
        
        var target = [[OLMessageController alloc] init];
        
        [target loadMessages];
        
        [OLMessage verifyThatAllExpectationsHaveBeenMet];
    }
    finally {
        [[OLUserSessionManager defaultSessionManager] setStatus:OLUserSessionLoggedOutStatus];
        OLMessage = OGMessage;
    }
}

- (void)testThatOLMessageControllerDoesSortMessagesByDate
{
    var messageOne = [[OLMessage alloc] init];
    [messageOne setDateSent:[CPDate dateWithTimeIntervalSinceNow:1]];
    var messageTwo = [[OLMessage alloc] init];
    [messageTwo setDateSent:[CPDate dateWithTimeIntervalSinceNow:-1]];
    var messageThree = [[OLMessage alloc] init];
    
    var target = [[OLMessageController alloc] init];
    
    target.messages = [messageOne, messageTwo, messageThree];
    
    [target sortMessages];
    
    [self assert:[messageOne, messageThree, messageTwo] equals:target.messages];
}

- (void)testThatOLMessageControllerDoesAddMessages
{
    var target = [[OLMessageController alloc] init];
    
    [target addMessage:[[OLMessage alloc] init]];
    
    [self assert:1 equals:[target.messages count]];
}

- (void)testThatOLMessageControllerDoesReloadsMessagesWhenUserChanges
{
    var OGMessage = OLMessage;
    
    try {
        OLMessage = moq();
        
        [OLMessage selector:@selector(findByToUsers:withCallback:) times:1];
        [[OLUserSessionManager defaultSessionManager] setStatus:OLUserSessionLoggedInStatus];
        
        var target = [[OLMessageController alloc] init];
        
        [target didReceiveUserDidChangeNotification:nil];
        
        [OLMessage verifyThatAllExpectationsHaveBeenMet];
    }
    finally {
        [[OLUserSessionManager defaultSessionManager] setStatus:OLUserSessionLoggedOutStatus];
        OLMessage = OGMessage;
    }
}

- (void)testThatOLMessageControllerDoesShowWindow
{
    var target = [[OLMessageController alloc] init];
    
    [target showMessageWindow:nil];
    
    [self assertTrue:YES];
}

- (void)testThatOLMessageControllerDoesSendMessage
{
    var target = [[OLMessageController alloc] init];
    var dict = [CPDictionary dictionary];
    [dict setObject:"test" forKey:"email"];
    [dict setObject:"test" forKey:"subject"];
    [dict setObject:"test   " forKey:"content"];
    
    var OGUser = OLUser;
    
    try {
        OLUser = moq();
        
        [OLUser selector:@selector(listWithCallback:) times:1];
        [OLUser selector:@selector(listWithCallback:) callback:function(a){
           var fun = a[0];
           
           fun(nil, YES); 
        }];
        
        var target = [[OLMessageController alloc] init];
        
        [target didSendMessage:dict];
        
        [OLUser verifyThatAllExpectationsHaveBeenMet];
    }
    finally {
        OLUser = OGUser;
    }
    
    [self assertTrue:YES];
}

- (void)testThatOLMessageControllerWillCreateRecord
{
    var target = [[OLMessageController alloc] init];
    [target willCreateRecord:nil];
    [self assertTrue:YES];
}

- (void)testThatOLMessageControllerDidCreateRecord
{
    var target = [[OLMessageController alloc] init];
    [target didCreateRecord:nil];
    [self assertTrue:YES];
}

- (void)testThatOLMessageControllerDoesHaveMailView
{
    var target = [[OLMessageController alloc] init];
    
    [self assertSettersAndGettersFor:@"mailView" on:target];
}

- (void)testThatOLMessageControllerDoesReturnCurrentNumberOfTableRows
{
    var target = [[OLMessageController alloc] init];
    
    [target addMessage:[[OLMessage alloc] init]];
    
    [self assert:1 equals:[target numberOfRowsInTableView:nil]];
}

- (void)assertSettersAndGettersFor:(CPString)name on:(id)object
{
    var setter = "set" + [[name substringToIndex:1] capitalizedString] + [name substringFromIndex:1] + ":";
    var value = "__test_value";

    [object performSelector:setter withObject:value];

    [self assert:value equals:[object performSelector:name]];
}

- (void)testThatOLMessageControllerDoesSetContentToSelectedMessageOnSelectionChange
{
    var tableView = moq();
    var target = [[OLMessageController alloc] init];
    var notification = [[CPNotification alloc] initWithName:@"Test" object:tableView userInfo:[CPDictionary dictionary]];
    
    [tableView selector:@selector(selectedRowIndexes) returns:[CPIndexSet indexSetWithIndex:0]];
    
    [target addMessage:[[OLMessage alloc] initFromUser:nil toUser:nil subject:@"No Subject" content:@"Test"]];
    
    [target tableViewSelectionDidChange:notification];
    
    [self assert:"Test" equals:[target.mailView.textView stringValue]];
}

@end