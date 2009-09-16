@import <AppKit/CPView.j>
@import <AppKit/CPCheckBox.j>
@import "Todo.j"

@implementation TodoView : CPView
{
    Todo _todo @accessors(property=todo);
    CPCheckBox _checkBox;
    
}

- (id)initWithFrame:(CGRect)frame withTodo:(Todo)todo
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        //_todo = todo;
        [self setTodo:todo];
        _checkBox = [CPCheckBox checkBoxWithTitle:[[self todo] text]];
        [_checkBox setTarget:self];
        [_checkBox setAction:@selector(toggleIsFinished:)];
        [self addSubview:_checkBox];
    }
    
    return self;
}

- (void)toggleIsFinished:(id)sender
{
    [[self todo] setIsFinished:![[self todo] isFinished]];
        
    console.log([[self todo] description]);
}

@end