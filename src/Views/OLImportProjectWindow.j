@import <AppKit/CPWindow.j>
@import "../Categories/CPView+Positioning.j"
@import "CPUploadButton.j"

var uploadURL = @"Upload/upload.php";

@implementation OLImportProjectWindow : CPWindow
{
    id      delegate        @accessors;
}

- (id)initWithContentRect:(CGRect)aFrame styleMask:(CPWindowStyleMask)aStyleMask
{
    self = [super initWithContentRect:aFrame styleMask:aStyleMask];
    if(self)
    {
        [self setTitle:@"Import..."];
        
        var contentView = [self contentView];
        
        var importNewVersion = [UploadButton buttonWithTitle:@"Replace with New Version"];
        [contentView addSubview:importNewVersion positioned:CPViewWidthCentered | CPViewTopAligned relativeTo:contentView withPadding:5.0];
		[importNewVersion setDelegate:self];
		[importNewVersion setURL:uploadURL];
        
        var importNewFile = [UploadButton buttonWithTitle:@"Import New File"];
        [contentView addSubview:importNewFile positioned:CPViewWidthCentered | CPViewBottomAligned relativeTo:contentView withPadding:5.0];
		[importNewVersion setDelegate:self];
		[importNewVersion setURL:uploadURL];
    }
    return self;
}

- (void)close
{
	[[CPApplication sharedApplication] stopModal];
	
	[super close];
}

@end

@implementation OLImportProjectWindow (UploadButtonDelegate)

- (void)uploadButton:(id)sender didChangeSelection:(CPString)selection
{   
	[sender submit];
}

- (void)uploadButtonDidBeginUpload:(id)sender
{
	[self close];
}

- (void)uploadButton:(id)sender didFinishUploadWithData:(CPString)response
{
    console.log(_cmd, response);
	[delegate handleServerResponse:response];
}

@end
