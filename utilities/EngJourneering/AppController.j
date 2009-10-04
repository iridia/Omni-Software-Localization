/*
 * AppController.j
 * EngJourneering
 *
 * Created by Chandler Kent on September 23, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "EJ+CPString.j"
@import "EJUser.j"
@import "EJTwitterController.j"
@import "EJGitHubController.j"
@import "EJRSSController.j"
@import "EJSourceView.j"

@implementation AppController : CPObject
{
    CPArray users;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
        
    var toolbar = [[CPToolbar alloc] initWithIdentifier:@"Toolbar"];
    [toolbar setDelegate:self];
    
    [theWindow setToolbar:toolbar];
    
    var bundle = [CPBundle mainBundle];
    var usersFromBundle = [bundle objectForInfoDictionaryKey:@"EJUsers"];
    
    var users = [];
    for (var i = 0; i < [usersFromBundle count]; i++)
    {
        var user = [[EJUser alloc] initWithDictionary:[usersFromBundle objectAtIndex:i]];
        [users addObject:user];
    }
    [users sortUsingSelector:@selector(compare:)];
    
    var sources = [bundle objectForInfoDictionaryKey:@"EJSources"];
    for (var i = 0; i < [sources count]; i++)
    {
        var source = [sources objectAtIndex:i];
        var key = [source objectForKey:@"key"];
        var classFromString = objj_getClass([source objectForKey:@"class"]);
        [[classFromString alloc] initWithUsers:users andKey:key];
    }
    
    var splitView = [[CPSplitView alloc] initWithFrame:[contentView bounds]];
    [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView setVertical:YES];
    
    var sourceView = [[EJSourceView alloc] initWithFrame:CGRectMake(0, 0, 200.0, CGRectGetHeight([contentView bounds])) users:users];
    [sourceView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView addSubview:sourceView];
    
    var detailView = [[EJDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([contentView bounds]) - CGRectGetWidth([sourceView bounds]), CGRectGetHeight([contentView bounds])) users:users];
    [detailView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView addSubview:detailView];
    
    [sourceView setDetailView:detailView];
    
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
