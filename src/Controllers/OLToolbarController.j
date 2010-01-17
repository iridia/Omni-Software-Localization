@import <AppKit/CPToolbar.j>

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
    CPToolbar            toolbar @accessors;
    CPString             loginValue;
}

- (id)init
{
    return [self initWithFeedbackController:nil loginController:nil projectController:nil glossaryController:nil messageController:nil];
}

- (id)initWithFeedbackController:(OLFeedbackController)aFeedbackController loginController:(OLLoginController)aLoginController
        projectController:(OLProjectController)aProjectController glossaryController:(OLGlossaryController)aGlossaryController
        messageController:(OLMessageController)aMessageController
{
    self = [super init];
    
    if (self)
    {
        feedbackController = aFeedbackController;
        loginController = aLoginController;
        projectController = aProjectController;
        glossaryController = aGlossaryController;
        messageController = aMessageController;
        loginValue = "Login / Register";
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(updateLoginInfo:)
            name:CPUserSessionManagerUserIdentifierDidChangeNotification
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

        [menuItem setTarget:loginController];
        [menuItem setAction:@selector(showLoginAndRegisterWindow:)];
        
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

- (void)updateLoginInfo:(CPNotification)notification
{
    [OLUser findByRecordID:[[CPUserSessionManager defaultManager] userIdentifier] withCallback:function(user)
        {
            loginValue = "Welcome, " + [user email]; 
            [toolbar _reloadToolbarItems];
        }];
}

@end