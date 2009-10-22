@import <AppKit/CPToolbar.j>

var OLFeedbackToolbarItemIdentifier = @"OLFeedbackToolbarItemIdentifier";

@implementation OLToolbarController : CPObject
{
    OLFeedbackController _feedbackController;
}

- (id)init
{
    console.warn("You should really be initializing this.");
    
    return [self initWithFeedbackController:nil];
}

- (id)initWithFeedbackController:(OLFeedbackController)feedbackController
{
    self = [super init];
    
    if (self)
    {
        _feedbackController = feedbackController;
    }
    
    return self;
}

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)toolbar
{
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)toolbar
{
    return [CPToolbarFlexibleSpaceItemIdentifier, OLFeedbackToolbarItemIdentifier];
}

- (CPToolbarItem)toolbar:(CPToolbar)toolbar itemForItemIdentifier:(CPString)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    var toolbarItem = [[CPToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    
    if (itemIdentifier === OLFeedbackToolbarItemIdentifier)
    {
        var feedbackButton = [[CPImage alloc] initWithContentsOfFile:"Resources/FeedbackButton.png" size:CPSizeMake(30, 25)],
        var feedbackButtonPushed = [[CPImage alloc] initWithContentsOfFile:"Resources/FeedbackButtonPushed.png" size:CPSizeMake(30, 25)];
            
        [toolbarItem setImage:feedbackButton];
        [toolbarItem setAlternateImage:feedbackButtonPushed];
        [toolbarItem setMinSize:CGSizeMake(32, 32)];
        [toolbarItem setMaxSize:CGSizeMake(32, 32)];
        [toolbarItem setLabel:"Send Feedback"];
        
        [toolbarItem setTarget:_feedbackController];
        [toolbarItem setAction:@selector(showFeedbackWindow:)];
    }

    return toolbarItem;
}

@end