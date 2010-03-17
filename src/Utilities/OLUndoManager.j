@import <Foundation/CPObject.j>

@import "../Controllers/OLMenuController.j"

@implementation OLUndoManager : CPObject

+ (void)registerUndoWithTarget:(id)target selector:(SEL)aSelector object:(id)object
{
    [[[[CPApp delegate] theWindow] undoManager] registerUndoWithTarget:target selector:aSelector object:object];
    
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemUndo]];
}

+ (void)undo
{
    [[[[CPApp delegate] theWindow] undoManager] undo];
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemRedo]];
    
    // if(![[[CPApp mainWindow] undoManager] canUndo])
    if([[[CPApp delegate] theWindow] undoManager]._undoStack.length <= 0)
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemUndo]];
    }
}

+ (void)redo
{
    [[[[CPApp delegate] theWindow] undoManager] redo];
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemUndo]];

    console.log("HERE");

    if(![[[[CPApp delegate] theWindow] undoManager] canRedo])
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemRedo]];
    }
}

@end
