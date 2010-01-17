@import <Foundation/CPUserSessionManager.j>

@import "../Models/OLProject.j"

var uploadedJSON = {"fileType":"zip","fileName":"Chess.app","resourcebundles":[{"name":"English.lproj","resources":[{"fileName":"Chess.app/Contents/Resources/English.lproj/InfoPlist.strings","fileType":"strings","dict":{"key":["","","",""],"string":["","","",""]},"comments_dict":{"key":["","","",""],"string":[" Localized versions of Info.plist keys ","","",""]}},{"fileName":"Chess.app/Contents/Resources/English.lproj/Localizable.strings","fileType":"strings","dict":{"key":["pawn_letter","knight_letter","bishop_letter","rook_letter","queen_letter","king_letter","versus","select_square","promote_to","king","queen","bishop","knight","rook","pawn","kings","queens","bishops","knights","rooks","pawns","white_king","white_queen","white_bishop","white_knight","white_rook","white_pawn","black_king","black_queen","black_bishop","black_knight","black_rook","black_pawn","new_msg","draw_msg","white_win_msg","black_win_msg","undo_msg","undos_msg","hint_msg","hints_msg","illegal_msg","white_move_msg","black_move_msg","casual_game","Wood","Metal","Marble","Grass","Fur","Glass"],"string":["P","N","B","R","Q","K","versus","select","promote to","king","queen","bishop","knight","rook","pawn","kings","queens","bishops","knights","rooks","pawns","white king","white queen","white bishop","white knight","white rook","white pawn","black king","black queen","black bishop","black knight","black rook","black pawn","New Game","Draw!","White wins!","Black wins!","1 Undo","%d Undos","1 Hint","%d Hints","Illegal Move!","White to Move","Black to Move","Casual Game","Wood","Metal","Marble","Grass","Fur","Glass"]},"comments_dict":{"key":["pawn_letter","knight_letter","bishop_letter","rook_letter","queen_letter","king_letter","versus","select_square","promote_to","king","queen","bishop","knight","rook","pawn","kings","queens","bishops","knights","rooks","pawns","white_king","white_queen","white_bishop","white_knight","white_rook","white_pawn","black_king","black_queen","black_bishop","black_knight","black_rook","black_pawn","new_msg","draw_msg","white_win_msg","black_win_msg","undo_msg","undos_msg","hint_msg","hints_msg","illegal_msg","white_move_msg","black_move_msg","casual_game","Wood","Metal","Marble","Grass","Fur","Glass"],"string":["  Single letter piece names P(awn) K(night) B(ishop) R(ook) Q(ueen) K(ing)  According to the PGN standard for chess notation, the following letters  are used internationally:  Czech        P J S V D K  Danish       B S L T D K  Dutch        O P L T D K  English      P N B R Q K  Estonian     P R O V L K  Finnish      P R L T D K  French       P C F T D R  German       B S L T D K  Hungarian    G H F B V K  Icelandic    P R B H D K  Italian      P C A T D R  Norwegian    B S L T D K  Polish       P S G W H K  Portuguese   P C B T D R  Romanian     P C N T D R  Spanish      P C A T D R  Swedish      B S L T D K","","","","","","  * Full piece names for VoiceOver. We can't decompose into color &amp; piece * because of gender agreement requirements in some languages. ","","","","","","","","","","","","","","","","","","","","","","","","","",""," Game outcomes and other title messages ","","","","","","","","","","",""," Style names ","","","","",""]}}]}]};

@implementation OLProjectTest : OJTestCase

- (void)testThatOLProjectDoesInitialize
{
    var target = [[OLProject alloc] init];
    [self assertNotNull:target];
}

- (void)testThatOLProjectDoesInitializeWithName
{
    var projectName = @"AProject";
    var target = [[OLProject alloc] initWithName:projectName];
    
    [self assertNotNull:target];
    [self assert:projectName equals:[target name]];
    [self assertTrue:[[CPArray array] isEqualToArray:[target resourceBundles]]];
}

- (void)testThatOLProjectDoesInitializeWithNameAndUserIdentifier
{
    var userID = @"1234";
    var target = [[OLProject alloc] initWithName:@"AProject" userIdentifier:userID];
    
    [self assertNotNull:target];
    [self assert:userID equals:[target userIdentifier]];
}

- (void)testThatOLProjectDoesAddResourceBundleCorrectly
{
    var resourceBundle = moq();
    
    var target = [[OLProject alloc] initWithName:@"AProject"];
    
    [target addResourceBundle:resourceBundle];
    
    [self assert:[resourceBundle resources] equals:[target resources]];
}

- (void)testThatOLProjectDoesInitWithCoder
{
    var coder = moq();
    
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:["OLProjectNameKey"]];
    [coder expectSelector:@selector(decodeObjectForKey:) times:1 arguments:["OLProjectResourceBundlesKey"]];
    
    var target = [[OLProject alloc] initWithCoder:coder];
    
    [coder verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOLProjectControllerCanCreateProjectFromJSON
{
    var newProject = [OLProject projectFromJSON:uploadedJSON];
    
    [self assertNotNull:newProject];
    [self assert:uploadedJSON.fileName equals:[newProject name]];
    [self assert:uploadedJSON.resourcebundles.length equals:[[newProject resourceBundles] count]];
}

- (void)testThatOLProjectControllerCreatesProjectAssociatedWithLoggedInUser
{
    var sessionManager = [CPUserSessionManager defaultManager];
    [sessionManager setStatus:CPUserSessionLoggedInStatus];
    var userIdentifier = @"12345";
    [sessionManager setUserIdentifier:userIdentifier]
    
    var newProject = [OLProject projectFromJSON:uploadedJSON];
    
    [self assert:userIdentifier equals:[newProject userIdentifier]];
}

- (void)testThatOLProjectDoesCloneNameCorrectly
{
    var target = [[OLProject alloc] initWithName:@"ATestProject" userIdentifier:@"user"];
    
    var clone = [target clone];
    
    [self assertTrue:[[clone name] isEqualToString:[target name]]];
    [self assert:clone notSame:target];
}

- (void)testThatOLProjectDoesCloneIdCorrectly
{
    var target = [[OLProject alloc] initWithName:@"ATestProject" userIdentifier:@"user"];

    var clone = [target clone];

    [self assertTrue:[[clone userIdentifier] isEqualToString:[target userIdentifier]]];
    [self assert:clone notSame:target];
}

- (void)testThatOLProjectDoesCloneResourceBundleArray
{
    var target = [[OLProject alloc] initWithName:@"ATestProject" userIdentifier:@"user"];
    
    [target addResourceBundle:moq()];

    var clone = [target clone];

    [self assert:[[clone resourceBundles] count] equals:[[target resourceBundles] count]];
    [self assert:clone notSame:target];
}

- (void)testThatOLProjectDoesCloneResourceBundles
{
    var target = [[OLProject alloc] initWithName:@"ATestProject" userIdentifier:@"user"];
    var bundleInTarget = moq();
    var clonedBundleInTarget = moq();
    [bundleInTarget selector:@selector(clone) returns:clonedBundleInTarget];
    [target addResourceBundle:bundleInTarget];

    var clone = [target clone];

    [self assert:clonedBundleInTarget equals:[[clone resourceBundles] objectAtIndex:0]];
    [self assert:clone notSame:target];
}

- (void)testThatOLProjectDoesGetCurrentProjectWithLineItem
{
    
}

@end