@import <Foundation/CPObject.j>

@import "OLLoginController.j"
@import "../Categories/CPDate+RelativeDate.j"
@import "../Models/OLUser.j";
@import "../Views/OLMessageWindow.j"
@import "../Views/OLMailView.j"
@import "../Models/OLMessage.j"

OLMessageControllerShouldCreateMessageNotification = @"OLMessageControllerShouldSendMessageNotification";

@implementation OLMessageController : CPObject
{
    CPArray         messages;
    OLMailView      mailView;
    OLMessageWindow messageWindow;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        messages = [CPArray array];
        
        messageWindow = [[OLMessageWindow alloc] initWithContentRect:CGRectMake(0, 0, 300, 300) styleMask:CPTitledWindowMask];
        [messageWindow setDelegate:self];
        
        [[CPNotificationCenter defaultCenter]
    	    addObserver:self
    		selector:@selector(didReceiveUserDidChangeNotification:)
    		name:OLUserSessionManagerUserDidChangeNotification
    		object:nil];
    		
    	[[CPNotificationCenter defaultCenter]
    	   addObserver:self
    	   selector:@selector(showMessageWindow:)
    	   name:OLMessageControllerShouldCreateMessageNotification
    	   object:nil];
    }
    
    return self;
}

- (void)setMailView:(OLMailView)aMailView
{
    if (mailView === aMailView)
        return;
    
    mailView = aMailView;
    
    [mailView setDelegate:self];
    [mailView setDataSource:self];
}

- (void)loadMessages
{
    messages = [CPArray array]; // Clear the current messages

    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userLoggedIn = [[OLUserSessionManager defaultSessionManager] userIdentifier];
        [OLMessage findByToUserID:userLoggedIn withCallback:function(message,isFinal)
    	{
            [self addMessage:message];
            if(isFinal)
            {
                [self sortMessages];
            }
        }];
    }
}

- (void)sortMessages
{
    messages = [messages sortedArrayUsingFunction:function(lhs, rhs, context){  
               return [[rhs dateSent] compare:[lhs dateSent]];
           }];
}

- (void)addMessage:(OLMessage)message
{
    [self insertObject:message inMessagesAtIndex:[messages count]];
}

- (void)insertObject:(OLMessage)message inMessagesAtIndex:(int)index
{
    [messages insertObject:message atIndex:index];
    [mailView reloadData];
}

@end

@implementation OLMessageController (Notifications)

- (void)didReceiveUserDidChangeNotification:(CPNotification)aNotification
{
    [self loadMessages];
    [mailView reloadData];
}

@end

@implementation OLMessageController (OLMessageWindowDelegate)

- (void)showMessageWindow:(id)sender
{
    if(![[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userInfo = [CPDictionary dictionary];
        [userInfo setObject:@"You must log in to send a message!" forKey:@"StatusMessageText"];
        [userInfo setObject:@selector(showMessageWindow:) forKey:@"SuccessfulLoginAction"];
        [userInfo setObject:self forKey:@"SuccessfulLoginTarget"];
        
        [[CPNotificationCenter defaultCenter]
            postNotificationName:OLLoginControllerShouldLoginNotification
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
    [OLUser listWithCallback:function(user, isFinal)
    {
        if(toUser === [user email])
        {
            wasFound = YES;
            var message = [[OLMessage alloc] initFromUser:fromUser toUser:user subject:subject content:text];
            [message setDelegate:self];
            [message saveWithCallback:function(){
                [self loadMessages]; 
                [mailView reloadData];
            }];
        }
        
        if(isFinal && !wasFound)
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

@implementation OLMessageController (OLMailTableViewDataSource)

- (int)numberOfRowsInTableView:(CPTableView)mailTableView
{
    return [messages count];
}

- (id)tableView:(CPTableView)mailTableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
    var message = [messages objectAtIndex:row];

    if ([tableColumn identifier] === OLMailViewFromUserIDColumnHeader)
    {
       return [message fromUserEmail];
    }
    else if ([tableColumn identifier] === OLMailViewSubjectColumnHeader)
    {
        return [message subject];
    }
    else if ([tableColumn identifier] === OLMailViewDateSentColumnHeader)
    {
        return [[message dateSent] getRelativeDateStringFromDate:[CPDate date]];
    }
        
    return nil;
}

@end

@implementation OLMessageController (OLMailTableViewDelegate)

- (void)tableViewSelectionDidChange:(CPNotification)notification
{
    var tableView = [notification object];
    var selectedRow = [[tableView selectedRowIndexes] firstIndex];
    var textToDisplay = @"";

    if (selectedRow >= 0 )
    {
       textToDisplay = [[messages objectAtIndex:selectedRow] content];
    }

    [mailView setContent:textToDisplay];
}

@end

@implementation OLMessageController (SidebarItem)

- (CPView)contentView
{
    return mailView;
}

@end
