@import <AppKit/CPToolbar.j>

var OLFeedbackToolbarItemIdentifier = @"OLFeedbackToolbarItemIdentifier";
var OLLoginToolbarItemIdentifier = @"OLLoginToolbarItemIdentifier";

@implementation OLToolbarController : CPObject
{
    OLFeedbackController feedbackController;
    OLProjectController  projectController;
    OLLoginController    loginController;
    OLGlossaryController glossaryController;
    CPMenuItem           loginMenuItem;
    CPToolbar            toolbar @accessors;
}

- (id)init
{
    return [self initWithFeedbackController:nil];
}

- (id)initWithFeedbackController:(OLFeedbackController)aFeedbackController loginController:(OLLoginController)aLoginController
        projectController:(OLProjectController)aProjectController glossaryController:(OLGlossaryController)aGlossaryController
{
    self = [super init];
    
    if (self)
    {
        feedbackController = aFeedbackController;
        loginController = aLoginController;
        projectController = aProjectController;
        glossaryController = aGlossaryController;
        
        [[CPNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(updateLoginInfo:)
            name:@"OLLoginDidLogin"
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
    return [CPToolbarFlexibleSpaceItemIdentifier, OLLoginToolbarItemIdentifier, OLFeedbackToolbarItemIdentifier];
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
        [menuItem setLabel:"Login / Register"];

        [menuItem setTarget:loginController];
        [menuItem setAction:@selector(showLogin:)];
        
        loginMenuItem = menuItem;
    }
    
    return menuItem;
}

- (void)updateLoginInfo:(CPNotification)notification
{
    var name = [[OLUser findByRecordID:[[CPUserSessionManager defaultManager] userIdentifier]] email];
    var theItem = [toolbar visibleItems][3];
    alert(@"Welcome, " +  name);
}

@end