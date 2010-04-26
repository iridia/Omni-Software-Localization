@import <Foundation/CPObject.j>

@import "../Controllers/OLMenuController.j"

@implementation OLUndoManager : CPObject

+ (void)registerUndoWithTarget:(id)target selector:(SEL)aSelector object:(id)object
{
    [[self _mainWindowUndoManager] registerUndoWithTarget:target selector:aSelector object:object];
    
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemUndo]];
}

+ (void)undo
{
    [[self _mainWindowUndoManager] undo];
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemRedo]];

    if(![[self _mainWindowUndoManager] canUndo])
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemUndo]];
    }
}

+ (void)redo
{
    [[self _mainWindowUndoManager] redo];
    [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldEnableItemsNotification 
        object:[OLMenuItemUndo]];

    if(![[self _mainWindowUndoManager] canRedo])
    {
        [[CPNotificationCenter defaultCenter] postNotificationName:OLMenuShouldDisableItemsNotification
            object:[OLMenuItemRedo]];
    }
}

+ (CPUndoManager)_mainWindowUndoManager
{
    return [[[CPApp delegate] theWindow] undoManager];
}

@end
