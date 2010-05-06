@import <AppKit/CPToolbar.j>

@import "../Utilities/OLUserSessionManager.j"
@import "OLMessageController.j"
@import "OLFeedbackController.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";
var OLFeedbackToolbarItemIdentifier = @"OLFeedbackToolbarItemIdentifier";
var OLLoginToolbarItemIdentifier = @"OLLoginToolbarItemIdentifier";
var OLLogoutToolbarItemIdentifier = @"OLLogoutToolbarItemIdentifier";
var OLMessageToolbarItemIdentifier = @"OLMessageToolbarItemIdentifier";


@implementation OLToolbarController : CPObject
{
    CPMenuItem           logoutMenuItem;
    CPMenuItem           loginMenuItem;
    CPToolbar            toolbar                @accessors;
    CPString             loginValue;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
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

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
    return [self toolbarDefaultItemIdentifiers:aToolbar];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
    return [OLMessageToolbarItemIdentifier, CPToolbarFlexibleSpaceItemIdentifier, OLLogoutToolbarItemIdentifier, OLLoginToolbarItemIdentifier, OLFeedbackToolbarItemIdentifier];
}

- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    var menuItem = [[CPToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if (itemIdentifier === OLFeedbackToolbarItemIdentifier)
    {
        var feedbackButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Feedback_Unpressed.png" size:CPSizeMake(32, 32)];

        var feedbackButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Feedback_Pressed.png" size:CPSizeMake(32, 32)];
            
        [menuItem setImage:feedbackButton];
        [menuItem setAlternateImage:feedbackButtonPushed];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:"Send Feedback"];
        
        [menuItem setTarget:self];
        [menuItem setAction:@selector(feedback:)];
    }
    else if(itemIdentifier === OLLogoutToolbarItemIdentifier)
    {
        var logoutButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Login_Unpressed.png" size:CPSizeMake(32, 32)];
        var logoutButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Login_Pressed.png" size:CPSizeMake(32, 32)];
        
        [menuItem setImage:logoutButton];
        [menuItem setAlternateImage:logoutButtonPushed];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:@"Logout"];

        [menuItem setTarget:self];
        [menuItem setAction:@selector(logout:)];
        
        logoutMenuItem = menuItem;
    }
    else if(itemIdentifier === OLLoginToolbarItemIdentifier)
    {
        var loginButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Login_Unpressed.png" size:CPSizeMake(32, 32)];
        var loginButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Login_Pressed.png" size:CPSizeMake(32, 32)];
            
        [menuItem setImage:loginButton];
        [menuItem setAlternateImage:loginButtonPushed];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:loginValue];

        [menuItem setTarget:self];
        [menuItem setAction:@selector(login:)];
        
        loginMenuItem = menuItem;
    }
    else if(itemIdentifier === OLMessageToolbarItemIdentifier)
    {
        var messageButton = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Mail_Unpressed.png" size:CPSizeMake(32, 32)];
        var messageButtonPushed = [[CPImage alloc] initWithContentsOfFile:@"Resources/Images/Mail_Pressed.png" size:CPSizeMake(32, 32)];
            
        [menuItem setImage:messageButton];
        [menuItem setAlternateImage:messageButtonPushed];
        [menuItem setMinSize:CGSizeMake(32, 32)];
        [menuItem setMaxSize:CGSizeMake(32, 32)];
        [menuItem setLabel:"New Message"];
        [menuItem setTag:@"new_message"];

        [menuItem setTarget:self];
        [menuItem setAction:@selector(newMessage:)];
        
        loginMenuItem = menuItem;
        
    }
    
    return menuItem;
}

- (void)login:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLoginControllerShouldLoginNotification
        object:self];
}

- (void)logout:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLLoginControllerShouldLogoutNotification
        object:self];
}

- (void)updateLoginInfo:(CPNotification)notification
{

    var user = [[OLUserSessionManager defaultSessionManager] user];
    if (user !== nil)
    {
        loginValue = [user email]; 
        [toolbar _reloadToolbarItems];
    }
    else
    {
        loginValue = @"Login / Register";
        [toolbar _reloadToolbarItems];
    }
}

- (void)newMessage:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLMessageControllerShouldCreateMessageNotification
        object:self];
}

- (void)feedback:(id)sender
{
    [[CPNotificationCenter defaultCenter]
        postNotificationName:OLFeedbackControllerShouldShowWindowNotification
        object:self];
}

@end