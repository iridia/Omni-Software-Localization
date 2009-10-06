/*
 * AppController.j
 * EngJourneering
 *
 * Created by Chandler Kent on September 23, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "Categories/EJ+CPString.j"
@import "Users/EJUserController.j"
@import "SourceControllers/EJSourceController.j"
@import "Views/EJSourceView.j"

@implementation AppController : CPObject
{
    EJUserController _userController;
    EJSourceController _sourceController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
        
    var toolbar = [[CPToolbar alloc] initWithIdentifier:@"Toolbar"];
    [toolbar setDelegate:self];
    
    [theWindow setToolbar:toolbar];
    
    // Set up the data controllers
    _userController = [[EJUserController alloc] init];
    _sourceController = [[EJSourceController alloc] initWithUserController:_userController];
    
    // Set up views
    var splitView = [[CPSplitView alloc] initWithFrame:[contentView bounds]];
    [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView setVertical:YES];
    
    var sourceView = [[EJSourceView alloc] initWithFrame:CGRectMake(0, 0, 200.0, CGRectGetHeight([contentView bounds]))];
    [sourceView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView addSubview:sourceView];
    
    var detailView = [[EJDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([contentView bounds]) - CGRectGetWidth([sourceView bounds]), CGRectGetHeight([contentView bounds]))];
    [detailView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView addSubview:detailView];
    
    [sourceView setDetailView:detailView];
    [sourceView setContent:[_userController users]];
    [contentView addSubview:splitView];
    
    [theWindow orderFront:self];
}

- (CPArray)toolbarDefaultItemIdentifiers:(CPToolbar)aToolbar
{
    return [];
}

- (CPArray)toolbarAllowedItemIdentifiers:(CPToolbar)aToolbar
{
    return [];
}

- (CPToolbarItem)toolbar:(CPToolbar)aToolbar itemForItemIdentifier:(CPString)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    return nil;
}

@end
