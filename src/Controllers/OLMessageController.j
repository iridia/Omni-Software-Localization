@import <Foundation/CPObject.j>

@import "../Models/OLUser.j";
@import "../Views/OLMessageWindow.j"
@import "../Models/OLMessage.j"

@implementation OLMessageController : CPObject
{
    CPString        contentText;
    OLMessage       selectedMessage;
    OLMessageWindow messageWindow;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        messageWindow = [[OLMessageWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
        [messageWindow setDelegate:self];
    }
    
    return self;
}

- (void)showMessageWindow:(id)sender
{
    if(![[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to send a message!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(showMessageWindow:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
        
        [[CPNotificationCenter defaultCenter]
            postNotificationName:@"OLUserShouldLoginNotification"
            object:nil
            userInfo:userInfo];
        
        return;
    }
    [[CPApplication sharedApplication] runModalForWindow:messageWindow];
}

- (void)didSendMessage:(CPDictionary)messageDictionary
{
    var toUser = [messageDictionary objectForKey:@"ToUserID"];
    var subject = [messageDictionary objectForKey:@"subject"];
    var text = [messageDictionary objectForKey:@"content"];
    var dateSent = [messageDictionary objectForKey:@"dateSent"];
    var fromUser = [[OLUserSessionManager defaultSessionManager] user];
    
    var wasFound = NO;
    [OLUser listWithCallback:function(user)
        {
            if(toUser === [user email])
            {
                wasFound = YES;
                var message = [[OLMessage alloc] initWithUserID:[fromUser email] subject:subject content:text to:toUser];
                [message setDelegate:self];
                [[CPNotificationCenter defaultCenter] postNotificationName:@"OLMessageCreatedNotification" object:message];
                [message save];
            }
        } 
        finalCallback:function(user)
        {
            if(!wasFound)
            {
                [messageWindow setStatus:@"Invalid To field."];
            }
        }];
}

- (void)willCreateRecord:(OLMessage)message
{
    [messageWindow showSendingMessageView];
}

- (void)didCreateRecord:(OLMessage)message
{
    [messageWindow showSentMessageView];
}

@end
