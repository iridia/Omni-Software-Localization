@import <Foundation/CPObject.j>

@import "../Models/OLUser.j";

@import "../Views/OLMessageWindow.j"
@import "../Models/OLMessage.j"

@implementation OLMessageController : CPObject
{
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
   
    if ([[CPUserSessionManager defaultManager] status] === CPUserSessionLoggedInStatus)
    {
    }
    else
    {
        //popup the user login without cancel button
    }
    var fromUser = [[CPUserSessionManager defaultManager] userIdentifier];
    [OLUser findByRecordID:fromUser withCallback:function(user)
    {
        var message = [[OLMessage alloc] initWithUserID:[user email] subject:subject content:text to:email];
        [message setDelegate:self];
        [message save];
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