@implementation TodosController : CPObject
{
    CPArray todos @accessors;
}

- (id)initWithTodos:(CPArray)someTodos
{
    todos = someTodos;
}

@end