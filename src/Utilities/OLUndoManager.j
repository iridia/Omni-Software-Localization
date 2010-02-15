@import <Foundation/CPObject.j>

@import "../Controllers/OLMenuController.j"

@implementation OLUndoManager : CPObject

+ (void)registerUndoWithTarget:(id)target selector:(SEL)aSelector object:(id)object
{
    [[[CPApp mainWindow] undoManager] registerUndoWithTarget:target selector:aSelector object:object];
    
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemUndo]];
}

+ (void)undo
{
    [[[CPApp mainWindow] undoManager] undo];
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemRedo]];
    
    // if(![[[CPApp mainWindow] undoManager] canUndo])
    if([[CPApp mainWindow] undoManager]._undoStack.length <= 0)
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemUndo]];
    }
}

+ (void)redo
{
    [[[CPApp mainWindow] undoManager] redo];
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemUndo]];

    if(![[[CPApp mainWindow] undoManager] canRedo])
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemRedo]];
    }
}

@end
