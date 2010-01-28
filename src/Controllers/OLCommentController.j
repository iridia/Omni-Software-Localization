@import <Foundation/CPObject.j>

@import "../Models/OLComment.j"

@implementation OLCommentController : CPObject
{
    CPArray     comments;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        comments = [CPArray array];
    }
    return self;
}

- (void)loadCommentsForItem:(id)anItem
{
    comments = [CPArray array];
    
    [OLComment findByObjectID:[anItem recordID] withCallback:function(comment)
    {
        if (comment)
        {
            [self addComment:comment];
        }
    }];
}

- (void)addComment:(OLComment)comment
{
    [comments insertObject:comment atIndex:[comments count]];
}

@end
