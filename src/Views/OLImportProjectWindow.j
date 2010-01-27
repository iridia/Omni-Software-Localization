@import <AppKit/CPWindow.j>
@import "../Categories/CPView+Positioning.j"
@import "CPUploadButton.j"

var uploadURL = @"Upload/upload.php";

@implementation OLImportProjectWindow : CPWindow
{
    id              delegate                    @accessors;
    
    CPView          importVersionAndFileView;
    CPView          importFileView;
    CPView          currentView;
    
    CPPopUpButton   fileButton                  @accessors;
    CPPopUpButton   languageButton              @accessors;
    CPButton        importNewFileUpload;
}

- (id)initWithContentRect:(CGRect)aFrame styleMask:(CPWindowStyleMask)aStyleMask
{
    self = [super initWithContentRect:aFrame styleMask:aStyleMask];
    if(self)
    {
        [self setTitle:@"Import..."];
        
        var contentView = [self contentView];
        
        var importVersionAndFileView = [[CPView alloc] initWithFrame:[contentView bounds]];
        var importFileView = [[CPView alloc] initWithFrame:[contentView bounds]];
        
        var importNewVersion = [UploadButton buttonWithTitle:@"Replace with New Version"];
        [importVersionAndFileView addSubview:importNewVersion positioned:CPViewWidthCentered | CPViewTopAligned 
            relativeTo:importVersionAndFileView withPadding:8.0];
		[importNewVersion setDelegate:self];
		[importNewVersion setURL:uploadURL];
        
        var importNewFile = [CPButton buttonWithTitle:@"Import New File"];
        [importVersionAndFileView addSubview:importNewFile positioned:CPViewWidthCentered | CPViewBelow 
            relativeTo:importNewVersion withPadding:12.0];
        [importNewFile setTarget:self];
        [importNewFile setAction:@selector(showReplaceFile:)];
		
		var selectFileText = [CPTextField labelWithTitle:@"replace the file"];
		[selectFileText setFont:[CPFont systemFontOfSize:16.0]];
		[selectFileText sizeToFit];
		var selectLanguageText = [CPTextField labelWithTitle:@"For the language"];
		[selectLanguageText setFont:[CPFont systemFontOfSize:16.0]];
		[selectLanguageText sizeToFit];
		
		fileButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 24.0)];
		[fileButton setTarget:self];
		[fileButton setAction:@selector(fileSelectionDidChange:)];
		
		languageButton = [[CPPopUpButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0, 24.0)];
		[languageButton setTarget:self];
		[languageButton setAction:@selector(languageSelectionDidChange:)];
        
        var back = [CPButton buttonWithTitle:@"Back"];
        [back setTarget:self];
        [back setAction:@selector(showMain:)];
        
        importNewFileUpload = [UploadButton buttonWithTitle:@"Import New File"];
		[importNewFileUpload setDelegate:self];
		[importNewFileUpload setURL:uploadURL];
        [importNewFileUpload setEnabled:NO];
		
		[importFileView addSubview:selectLanguageText positioned:CPViewWidthCentered | CPViewTopAligned
		    relativeTo:importFileView withPadding:5.0];
		[importFileView addSubview:languageButton positioned:CPViewWidthCentered | CPViewBelow
		    relativeTo:selectLanguageText withPadding:5.0];
		[importFileView addSubview:selectFileText positioned:CPViewWidthCentered | CPViewBelow
		    relativeTo:languageButton withPadding:5.0];
		[importFileView addSubview:fileButton positioned:CPViewWidthCentered | CPViewBelow
		    relativeTo:selectFileText withPadding:5.0];
		    
		    
		[importFileView addSubview:importNewFileUpload positioned:CPViewRightAligned | CPViewBottomAligned
		    relativeTo:importFileView withPadding:5.0];
		[importFileView addSubview:back positioned:CPViewHeightSame | CPViewOnTheLeft
		    relativeTo:importNewFileUpload withPadding:5.0];
		    
		[contentView addSubview:importVersionAndFileView];
    }
    return self;
}

- (void)setDelegate:(id)aDelegate
{
    delegate = aDelegate;
    
    [self reloadLanguageData];
}

- (void)reloadLanguageData
{
    [languageButton removeAllItems];
    [languageButton addItemsWithTitles:[delegate titlesOfLanguages]];
}

- (void)reloadFileData
{
    [fileButton removeAllItems];
    [fileButton addItemsWithTitles:[delegate titlesOfFiles]];
}

- (void)showReplaceFile:(id)sender
{       
    if(currentView !== importFileView)
    {
        var currentFrame = [self frame];
        currentFrame.size.height += 100;
        [self setFrame:currentFrame display:YES animate:YES];
        [self reloadLanguageData];
        [[self contentView] replaceSubview:importVersionAndFileView with:importFileView];
        currentView = importFileView;
    }
}

- (void)showMain:(id)sender
{
    if(currentView !== importVersionAndFileView)
    {
        var currentFrame = [self frame];
        currentFrame.size.height -= 100;
        [self setFrame:currentFrame display:sender !== delegate animate:sender !== delegate];
    
        [[self contentView] replaceSubview:importFileView with:importVersionAndFileView];
        
        currentView = importVersionAndFileView;
    }
}

- (void)fileSelectionDidChange:(id)sender
{
    [importNewFileUpload setEnabled:YES];
}

- (void)languageSelectionDidChange:(id)sender
{
    [self reloadFileData];
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
