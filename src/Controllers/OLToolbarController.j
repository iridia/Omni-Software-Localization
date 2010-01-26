@import <AppKit/CPToolbar.j>

@import "../Utilities/OLUserSessionManager.j"
@import "OLMessageController.j"
@import "OLFeedbackController.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";
var OLFeedbackToolbarItemIdentifier = @"OLFeedbackToolbarItemIdentifier";
var OLLoginToolbarItemIdentifier = @"OLLoginToolbarItemIdentifier";
var OLMessageToolbarItemIdentifier = @"OLMessageToolbarItemIdentifier";

// Notifications
OLToolbarControllerShouldCreateNewMessage = @"OLToolbarControllerShouldCreateNewMessage";
OLToolbarControllerShouldLogin = @"OLToolbarControllerShouldLogin";


@implementation OLToolbarController : CPObject
{
    OLFeedbackController feedbackController;
    CPMenuItem           loginMenuItem;
    CPToolbar            toolbar                @accessors;
    CPString             loginValue;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        feedbackController = [[OLFeedbackController alloc] init];
        loginValue = "Login / Register";
        
        toolbar = [[CPToolbar alloc] initWithIdentifier:OLMainToolbarIdentifier];
        [toolbar setDelegate:self];
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(updateLoginInfo:)
            name:OLUserSessionManagerUserDidChangeNotification
            object:nil];
    }
    
    return self;
}

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)toolbar
{
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)toolbar
{
    return [OLMessageToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, OLLoginToolbarItemIdentifier, OLFeedbackToolbarItemIdentifier];
}

- (CPToolbarItem)toolbar:(CPToolbar)toolbar itemForItemIdentifier:(CPString)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    var menuItem = [[CPToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if (itemIdentifier === OLFeedbackToolbarItemIdentifier)
    {
        var feedbackButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Feedback.png" size:CPSizeMake(32, 32)];

        var feedbackButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Feedback.png" size:CPSizeMake(32, 32)];
            
        [menuItem setImage:feedbackButton];
        [menuItem setAlternateImage:feedbackButtonPushed];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:"Send Feedback"];
        
        [menuItem setTarget:feedbackController];
        [menuItem setAction:@selector(showFeedbackWindow:)];
    }
    else if(itemIdentifier === OLLoginToolbarItemIdentifier)
    {
        var loginButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/User.png" size:CPSizeMake(32, 32)];
        var loginButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/User.png" size:CPSizeMake(32, 32)];
            
        [menuItem setImage:loginButton];
        [menuItem setAlternateImage:loginButton];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:loginValue];

        [menuItem setTarget:self];
        [menuItem setAction:@selector(login:)];
        
        loginMenuItem = menuItem;
    }
    else if(itemIdentifier === OLMessageToolbarItemIdentifier)
    {
        var messageButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Dialog.png" size:CPSizeMake(32, 32)];
        var messageButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Dialog.png" size:CPSizeMake(32, 32)];
            
        [menuItem setImage:messageButton];
        [menuItem setAlternateImage:messageButton];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:"New Message"];

        [menuItem setTarget:self];
        [menuItem setAction:@selector(newMessage:)];
        
        loginMenuItem = menuItem;
        
    }
    
    return menuItem;
}

- (void)login:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLToolbarControllerShouldLogin
        object:self];
}

- (void)updateLoginInfo:(CPNotification)notification
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    loginValue = "Welcome, " + [user email]; 
    [toolbar _reloadToolbarItems];
}

- (void)newMessage:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLToolbarControllerShouldCreateNewMessage
        object:self];
}

@end