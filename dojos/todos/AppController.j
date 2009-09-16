/*
 * AppController.j
 * todos
 *
 * Created by You on September 16, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import "Todo.j"
@import "TodoView.j"


@implementation AppController : CPObject
{
    CPArray todos;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
        contentView = [theWindow contentView];

    //todos = []; // quicker way - we'll use this
    //todos = [[CPArray alloc] init]; // full way
    var todo1 = [[Todo alloc] initWithText:@"Todo1"]; //always put @
    var todo2 = [[Todo alloc] initWithText:@"Todo2"]; //always put @
    var todo3 = [[Todo alloc] initWithText:@"Todo3"]; //always put @
    
    todos = [[CPArray alloc] initWithObjects:todo1, todo2, todo3, nil];
    
    console.log([todos description]);
    
    [theWindow orderFront:self];
    
    var todoView = [[TodoView alloc] initWithFrame:CGRectMake(0,0,200,100) withTodo:todos[1]];
    
    [contentView addSubview:todoView];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

@end
