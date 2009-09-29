/*
 * AppController.j
 * EngJourneering
 *
 * Created by Chandler Kent on September 23, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "OSL+CPString.j"
@import "User.j"
@import "TwitterController.j"
@import "GitHubController.j"

@import "CKSourceView.j"

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
        
    var chandler = [[User alloc] initWithName:@"Chandler" handles:[[CPDictionary alloc] initWithObjects:[@"chandlerkent", @"Chandler Kent"] forKeys:[@"twitter", @"github"]]];
    var derek = [[User alloc] initWithName:@"Derek" handles:[[CPDictionary alloc] initWithObjects:[@"hammerdr", @"Derek Hammer"] forKeys:[@"twitter", @"github"]]];
    var kyle = [[User alloc] initWithName:@"Kyle" handles:[[CPDictionary alloc] initWithObjects:[@"rhodesk", @"Kyle Rhodes"] forKeys:[@"twitter", @"github"]]];
    var caleb = [[User alloc] initWithName:@"Caleb" handles:[[CPDictionary alloc] initWithObjects:[@"allencw", @"Caleb Allen"] forKeys:[@"twitter", @"github"]]];

    users = [chandler, derek, caleb, kyle];
    
    var twitterController = [[TwitterController alloc] initWithUsers:users andKey:@"twitter"];
    var gitHubController = [[GitHubController alloc] initWithUsers:users andKey:@"github"];
    
    var splitView = [[CPSplitView alloc] initWithFrame:[contentView bounds]];
    [splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView setVertical:YES];
    
    var sourceView = [[CKSourceView alloc] initWithFrame:CGRectMake(0, 0, 200.0, CGRectGetHeight([contentView bounds])) users:users];
    [sourceView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
    [splitView addSubview:sourceView];
    
    var detailView = [[CKDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([contentView bounds]) - CGRectGetWidth([sourceView bounds]), CGRectGetHeight([contentView bounds])) users:users];
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
