@import <Foundation/CPObject.j>

@import "OLLoginController.j"
@import "../Categories/CPDate+RelativeDate.j"
@import "../Models/OLUser.j";
@import "../Views/OLMessageWindow.j"
@import "../Views/OLMailView.j"
@import "../Models/OLMessage.j"

OLMessageControllerShouldCreateMessageNotification = @"OLMessageControllerShouldSendMessageNotification";
OLMessageControllerShouldShowBroadcastViewNotification = @"OLMessageControllerShouldShowBroadcastViewNotification";

@implementation OLMessageController : CPObject
{
    CPArray         messages;
    OLMailView      mailView        @accessors;
    OLMessageWindow messageWindow;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {            
        mailView = [[OLMailView alloc] initWithFrame:CGRectMake(0.0, 0.0, 500.0, 500.0)];
        [mailView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [mailView setDelegate:self];
        [mailView setDataSource:self];
        
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
    	   selector:@selector(createMessage:)
    	   name:OLMessageControllerShouldCreateMessageNotification
    	   object:nil];
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(createBroadcastMessage:)
            name:OLMessageControllerShouldShowBroadcastViewNotification
            object:nil];
    }
    
    return self;
}

- (void)createBroadcastMessage:(CPNotification)notification
{
    var project = [[notification userInfo] objectForKey:@"project"];
    [messageWindow setIsBroadcastMessage:YES forProject:project];
    [self showMessageWindow:self];
}

- (void)createMessage:(CPNotification)notification
{
    [messageWindow setIsBroadcastMessage:NO forProject:nil];
    [self showMessageWindow:self];
}

- (void)loadMessages
{
    messages = [CPArray array]; // Clear the current messages

    if ([[OLUserSessionManager defaultSessionManager] isUserLoggedIn])
    {
        var userLoggedIn = [[OLUserSessionManager defaultSessionManager] userIdentifier];
        [OLMessage findByReceivers:userLoggedIn withCallback:function(message, isFinal)
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
    [messageWindow isBeingShown];
}

- (void)didSendMessage:(CPDictionary)messageDictionary
{
    var toUser = [messageDictionary objectForKey:@"email"];
    var subject = [messageDictionary objectForKey:@"subject"];
    var text = [messageDictionary objectForKey:@"content"];
    var sender = [[OLUserSessionManager defaultSessionManager] user];
    
    var wasFound = NO;
    [OLUser listWithCallback:function(user, isFinal)
    {
        if(toUser === [user email])
        {
            wasFound = YES;
            var message = [[OLMessage alloc] initWithSender:sender receivers:[user] subject:subject content:text];
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

- (void)didSendBroadcastMessage:(CPDictionary)messageDictionary
{
    var subject = [messageDictionary objectForKey:@"subject"];
    var content = [messageDictionary objectForKey:@"content"];
    var project = [messageDictionary objectForKey:@"project"];
    var sender = [[OLUserSessionManager defaultSessionManager] user];
    
    var toUsers = [project subscribers];
    var message = [[OLMessage alloc] initWithSender:sender receivers:toUsers subject:subject content:content];
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
       return [message senderEmail];
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
