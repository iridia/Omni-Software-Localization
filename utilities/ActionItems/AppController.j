/*
 * AppController.j
 * ActionItems
 *
 * Created by Caleb Allen on October 4, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import "OSL+CPString.j"
@import "WikiPage.j"
@import "GitHubWikiController.j"

@import "CKSourceView.j"

@implementation AppController : CPObject
{
	CPArray pages;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];
        
	/* Uncomment the following lines to enable the toolbar */
//	var toolbar = [[CPToolbar alloc] initWithIdentifier:@"Toolbar"];
//	[toolbar setDelegate:self];
//	[theWindow setToolbar:toolbar];

	var advisorMeetings = [[WikiPage alloc] initWithName:@"Advisor Meetings" withPath:@"advisor-meetings"];
	var clientMeetings = [[WikiPage alloc] initWithName:@"Client Meetings" withPath:@"client-meetings"];
	
	pages = [advisorMeetings, clientMeetings];
	
	
	var gitHubWikiController = [[GitHubWikiController alloc] initWithPages:pages];
	
	
	
	
	var splitView = [[CPSplitView alloc] initWithFrame:[contentView bounds]];
	[splitView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[splitView setVertical:YES];
	
	var sourceView = [[CKSourceView alloc] initWithFrame:CGRectMake(0, 0, 200.0, CGRectGetHeight([contentView bounds])) sources:pages];
	[sourceView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
	[splitView addSubview:sourceView];
    
	var detailView = [[CKDetailView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([contentView bounds]) - CGRectGetWidth([sourceView bounds]), CGRectGetHeight([contentView bounds])) sources:pages];
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
