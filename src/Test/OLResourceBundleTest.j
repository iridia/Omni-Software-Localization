@import <OJMoq/OJMoq.j>
@import "../Models/OLResourceBundle.j"

var json = {"name":"English.lproj","resources":[{"fileName":"Chess.app/Contents/Resources/English.lproj/InfoPlist.strings","fileType":"strings","dict":{"key":["","","",""],"string":["","","",""]},"comments_dict":{"key":["","","",""],"string":[" Localized versions of Info.plist keys ","","",""]}},{"fileName":"Chess.app/Contents/Resources/English.lproj/Localizable.strings","fileType":"strings","dict":{"key":["pawn_letter","knight_letter","bishop_letter","rook_letter","queen_letter","king_letter","versus","select_square","promote_to","king","queen","bishop","knight","rook","pawn","kings","queens","bishops","knights","rooks","pawns","white_king","white_queen","white_bishop","white_knight","white_rook","white_pawn","black_king","black_queen","black_bishop","black_knight","black_rook","black_pawn","new_msg","draw_msg","white_win_msg","black_win_msg","undo_msg","undos_msg","hint_msg","hints_msg","illegal_msg","white_move_msg","black_move_msg","casual_game","Wood","Metal","Marble","Grass","Fur","Glass"],"string":["P","N","B","R","Q","K","versus","select","promote to","king","queen","bishop","knight","rook","pawn","kings","queens","bishops","knights","rooks","pawns","white king","white queen","white bishop","white knight","white rook","white pawn","black king","black queen","black bishop","black knight","black rook","black pawn","New Game","Draw!","White wins!","Black wins!","1 Undo","%d Undos","1 Hint","%d Hints","Illegal Move!","White to Move","Black to Move","Casual Game","Wood","Metal","Marble","Grass","Fur","Glass"]},"comments_dict":{"key":["pawn_letter","knight_letter","bishop_letter","rook_letter","queen_letter","king_letter","versus","select_square","promote_to","king","queen","bishop","knight","rook","pawn","kings","queens","bishops","knights","rooks","pawns","white_king","white_queen","white_bishop","white_knight","white_rook","white_pawn","black_king","black_queen","black_bishop","black_knight","black_rook","black_pawn","new_msg","draw_msg","white_win_msg","black_win_msg","undo_msg","undos_msg","hint_msg","hints_msg","illegal_msg","white_move_msg","black_move_msg","casual_game","Wood","Metal","Marble","Grass","Fur","Glass"],"string":["  Single letter piece names P(awn) K(night) B(ishop) R(ook) Q(ueen) K(ing)  According to the PGN standard for chess notation, the following letters  are used internationally:  Czech        P J S V D K  Danish       B S L T D K  Dutch        O P L T D K  English      P N B R Q K  Estonian     P R O V L K  Finnish      P R L T D K  French       P C F T D R  German       B S L T D K  Hungarian    G H F B V K  Icelandic    P R B H D K  Italian      P C A T D R  Norwegian    B S L T D K  Polish       P S G W H K  Portuguese   P C B T D R  Romanian     P C N T D R  Spanish      P C A T D R  Swedish      B S L T D K","","","","","","  * Full piece names for VoiceOver. We can't decompose into color &amp; piece * because of gender agreement requirements in some languages. ","","","","","","","","","","","","","","","","","","","","","","","","","",""," Game outcomes and other title messages ","","","","","","","","","","",""," Style names ","","","","",""]}}]};

@implementation OLResourceBundleTest : OJTestCase
{
    JSObject testParams;
    OLResourceBundle target;
}

- (void)setUp
{
    var language = [[OLLanguage alloc] initWithName:@"English"];
    
    testParams = {
        "resources": ["1", "2", "3"],
        "language": language
    };
    
    target = [[OLResourceBundle alloc] initWithResources:testParams.resources language:testParams.language];
}

- (void)testThatOLResourceBundleDoesCreateResourceBundleFromJSON
{
    var resourceBundle = [OLResourceBundle resourceBundleFromJSON:json];
    
    [self assertNotNull:resourceBundle];
    [self assert:json.resources.length equals:[[resourceBundle resources] count]];
}

- (void)testThatOLResourceBundleDoesInitialize
{
    [self assertNotNull:target];
    [self assertTrue:[testParams.resources isEqual:[target resources]]];
    [self assert:testParams.language equals:[target language]];
}

- (void)testThatOLResourceBundleDoesInitalizeWithLanguageOnly
{
    var resourceBundle = [[OLResourceBundle alloc] initWithLanguage:testParams.language];
    [self assertNotNull:resourceBundle];
    [self assert:testParams.language equals:[resourceBundle language]];
}

- (void)testThatOLResourceBundleDoesInsertObjectsInResources
{
    var resource = moq();
    
    [target insertObject:resource inResourcesAtIndex:0];
    
    [self assert:resource equals:[[target resources] objectAtIndex:0]];
}

- (void)testThatOLResourceBundleDoesReplaceObjectsInResources
{
    var resource = moq();
    var replacementResource = moq();

    [target insertObject:resource inResourcesAtIndex:0];
    [target replaceObjectInResourcesAtIndex:0 withObject:replacementResource];

    [self assert:replacementResource equals:[[target resources] objectAtIndex:0]];
}

- (void)testThatOLResourceBundleDoesCloneLanguageCorrectly
{
    var language = moq();
    var resourceBundle = [[OLResourceBundle alloc] initWithLanguage:language];
    
    var clonedLanguage = moq();
    [language selector:@selector(clone) returns:clonedLanguage];
    
    var clone = [resourceBundle clone];
    
    [self assert:clonedLanguage equals:[clone language]];
}

- (void)testThatOLResourceBundleDoesCloneResourceArray
{
    var resourceBundle = [[OLResourceBundle alloc] initWithResources:[moq(), moq()] language:moq()];
    
    var clone = [resourceBundle clone];
    
    [self assert:[[clone resources] count] equals:[[resourceBundle resources] count]];
}

- (void)testThatOLResourceBundleDoesCloneResourcesCorrectly
{
    var resource = moq();
    var target = [[OLResourceBundle alloc] initWithResources:[resource] language:moq()];
    
    var clonedResource = moq();
    [resource selector:@selector(clone) returns:clonedResource];
    
    var clone = [target clone];
    
    [self assert:[[clone resources] objectAtIndex:0] equals:clonedResource];
}

- (void)testThatOLResourceBundleDoesInitializeWithCoder
{
    var coder = moq();
    
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.language arguments:[@"OLResourceBundleLanguageKey"]];
    [coder selector:@selector(decodeObjectForKey:) returns:testParams.resources arguments:[@"OLResourceBundleResourcesKey"]];
	
	var resourceBundle = [[OLResourceBundle alloc] initWithCoder:coder];

	[self assert:testParams.language equals:[resourceBundle language]];
	[self assert:testParams.resources equals:[resourceBundle resources]];
}

- (void)testThatOLResourceBundleDoesEncodeWithCoder
{
	var coder = moq();
	
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.language, @"OLResourceBundleLanguageKey"]];
	[coder selector:@selector(encodeObject:forKey:) times:1 arguments:[testParams.resources, @"OLResourceBundleResourcesKey"]];

	[target encodeWithCoder:coder];
	[coder verifyThatAllExpectationsHaveBeenMet];
}

@end