@import <AppKit/CPCollectionView.j>
@import "TodoView.j"

@implementation TodosListView : CPCollectionView
{
}

- (id)initWithFrame:(CGRect)rect todos:(CPArray)todos
{
    self = [super initWithFrame:rect];
    
    if (self)
    {
        var todoItemView = [[CPCollectionViewItem alloc] init];
        [todoItemView setView:[[TodoView alloc] initWithFrame:CGRectMakeZero()]];
        
        [self setItemPrototype:todoItemView];
        
        [self setMinItemSize:CGSizeMake(rect.size.width, 24)];
        [self setMaxItemSize:CGSizeMake(rect.size.width, 24)];
        [self setMaxNumberOfColumns:1];
        [self setAutoresizingMask:CPViewWidthSizable];
        
        [self setContent:todos];
    }
    
    return self;
}

@end