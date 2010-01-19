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
    [[CPApplication sharedApplication] runModalForWindow:messageWindow];
}

- (void)didSendMessage:(CPDictionary)messageDictionary
{
    var email = [messageDictionary objectForKey:@"email"];
    var subject = [messageDictionary objectForKey:@"subject"];
    var text = [messageDictionary objectForKey:@"content"];
    var dateSent = [messageDictionary objectForKey:@"dateSent"];
   
    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
    }
    else
    {
        //popup the user login without cancel button
    }
    
    var fromUser = [[OLUserSessionManager defaultSessionManager] user];
    var message = [[OLMessage alloc] initWithUserID:[fromUser email] subject:subject content:text to:email];
    [message setDelegate:self];
    [[CPNotificationCenter defaultCenter] postNotificationName:@"OLMessageCreatedNotification" object:message];
    [message save];
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
