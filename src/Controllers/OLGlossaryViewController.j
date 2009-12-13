@import "CPUploadButton.j"
@import "OLProjectController.j"

/*!
 * OLUploadEmptyGlossaryViewController
 *
 * The screen that is displayed when a glossary is created, but no file associated with it.
 */
@implementation OLUploadEmptyGlossaryViewController : CPViewController
{
	id delegate @accessors;
	OLGlossary glossary @accessors;
}

-(id)initWithCibName:(CPString)aName bundle:(CPBundle)aCibBundleOrNil owner:(id)anOwner
{
	return [self initWithCibName:aName bundle:aCibBundleOrNil owner:self];
}

-(void)uploadButton:(CPButton)aButton didFinishUploadWithData:(CPString)someData
{	
	var jsonResponse = eval("("+someData+")");
	var lineItemKeys = jsonResponse.dict.key;
	var lineItemStrings = jsonResponse.dict.string;
 
	if(jsonResponse.fileType == "strings")
	{
		var lineItemComments = jsonResponse.comments_dict.string;
 
		for (var i = 0; i < [lineItemKeys count]; i++)
		{
			[glossary addLineItem:[[OLLineItem alloc] initWithIdentifier:lineItemKeys[i] value:lineItemStrings[i] comment:lineItemComments[i]]];
		}	
	}
	
	[glossary save];
}

@end