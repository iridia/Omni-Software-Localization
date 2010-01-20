@import <AppKit/CPToolbar.j>

@import "../Utilities/OLUserSessionManager.j"

var OLMainToolbarIdentifier = @"OLMainToolbarIdentifier";
var OLFeedbackToolbarItemIdentifier = @"OLFeedbackToolbarItemIdentifier";
var OLLoginToolbarItemIdentifier = @"OLLoginToolbarItemIdentifier";
var OLMessageToolbarItemIdentifier = @"OLMessageToolbarItemIdentifier";

@implementation OLToolbarController : CPObject
{
    OLFeedbackController feedbackController;
    OLProjectController  projectController;
    OLLoginController    loginController;
    OLGlossaryController glossaryController;
    OLMessageController  messageController;
    CPMenuItem           loginMenuItem;
    CPToolbar            toolbar                @accessors;
    CPString             loginValue;
}

- (id)init
{
    return [self initWithFeedbackController:nil messageController:nil];
}

- (id)initWithFeedbackController:(OLFeedbackController)aFeedbackController messageController:(OLMessageController)aMessageController
{
    self = [super init];
    
    if (self)
    {
        feedbackController = aFeedbackController;
        messageController = aMessageController;
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

        [menuItem setTarget:messageController];
        [menuItem setAction:@selector(showMessageWindow:)];
        
        loginMenuItem = menuItem;
        
    }
    
    return menuItem;
}

- (void)login:(id)sender
{
    [[CPNotificationCenter defaultCenter] postNotificationName:@"OLUserShouldLoginNotification" object:self userInfo:[CPDictionary dictionary]];
}

- (void)updateLoginInfo:(CPNotification)notification
{
    var user = [[OLUserSessionManager defaultSessionManager] user];
    loginValue = "Welcome, " + [user email]; 
    [toolbar _reloadToolbarItems];
}

@end