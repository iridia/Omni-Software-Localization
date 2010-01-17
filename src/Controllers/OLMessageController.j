@import <Foundation/CPObject.j>

@import "../views/OLMessageWindow.j"
@import "../models/OLMessage.j"

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
    
    var message = [[OLMessage alloc] initWithUserID:email subject:subject content:text];
    [message setDelegate:self];
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