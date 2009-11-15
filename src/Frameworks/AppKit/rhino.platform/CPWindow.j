I;25;Foundation/CPCountedSet.jI;33;Foundation/CPNotificationCenter.jI;26;Foundation/CPUndoManager.ji;12;CGGeometry.ji;13;CPAnimation.ji;13;CPResponder.ji;10;CPScreen.ji;18;CPPlatformWindow.jc;50887;
CPBorderlessWindowMask=0;
CPTitledWindowMask=1<<0;
CPClosableWindowMask=1<<1;
CPMiniaturizableWindowMask=1<<2;
CPResizableWindowMask=1<<3;
CPTexturedBackgroundWindowMask=1<<8;
CPBorderlessBridgeWindowMask=1<<20;
CPHUDBackgroundWindowMask=1<<21;
CPWindowNotSizable=0;
CPWindowMinXMargin=1;
CPWindowWidthSizable=2;
CPWindowMaxXMargin=4;
CPWindowMinYMargin=8;
CPWindowHeightSizable=16;
CPWindowMaxYMargin=32;
CPBackgroundWindowLevel=-1;
CPNormalWindowLevel=0;
CPFloatingWindowLevel=3;
CPSubmenuWindowLevel=3;
CPTornOffMenuWindowLevel=3;
CPMainMenuWindowLevel=24;
CPStatusWindowLevel=25;
CPModalPanelWindowLevel=8;
CPPopUpMenuWindowLevel=101;
CPDraggingWindowLevel=500;
CPScreenSaverWindowLevel=1000;
CPWindowOut=0;
CPWindowAbove=1;
CPWindowBelow=2;
CPWindowWillCloseNotification="CPWindowWillCloseNotification";
CPWindowDidBecomeMainNotification="CPWindowDidBecomeMainNotification";
CPWindowDidResignMainNotification="CPWindowDidResignMainNotification";
CPWindowDidMoveNotification="CPWindowDidMoveNotification";
CPWindowWillBeginSheetNotification="CPWindowWillBeginSheetNotification";
CPWindowDidEndSheetNotification="CPWindowDidEndSheetNotification";
CPWindowDidMiniaturizeNotification="CPWindowDidMiniaturizeNotification";
CPWindowWillMiniaturizeNotification="CPWindowWillMiniaturizeNotification";
CPWindowDidDeminiaturizeNotification="CPWindowDidDeminiaturizeNotification";
CPWindowShadowStyleStandard=0;
CPWindowShadowStyleMenu=1;
CPWindowShadowStylePanel=2;
var _1=20,_2=19,_3=10,_4=10,_5=5,_6=nil;
var _7=nil,_8=nil;
var _9=objj_allocateClassPair(CPResponder,"CPWindow"),_a=_9.isa;
class_addIvars(_9,[new objj_ivar("_platformWindow"),new objj_ivar("_windowNumber"),new objj_ivar("_styleMask"),new objj_ivar("_frame"),new objj_ivar("_level"),new objj_ivar("_isVisible"),new objj_ivar("_isMiniaturized"),new objj_ivar("_isAnimating"),new objj_ivar("_hasShadow"),new objj_ivar("_isMovableByWindowBackground"),new objj_ivar("_shadowStyle"),new objj_ivar("_supportsMultipleDocuments"),new objj_ivar("_isDocumentEdited"),new objj_ivar("_isDocumentSaving"),new objj_ivar("_shadowView"),new objj_ivar("_windowView"),new objj_ivar("_contentView"),new objj_ivar("_toolbarView"),new objj_ivar("_mouseEnteredStack"),new objj_ivar("_leftMouseDownView"),new objj_ivar("_rightMouseDownView"),new objj_ivar("_toolbar"),new objj_ivar("_firstResponder"),new objj_ivar("_initialFirstResponder"),new objj_ivar("_delegate"),new objj_ivar("_title"),new objj_ivar("_acceptsMouseMovedEvents"),new objj_ivar("_ignoresMouseEvents"),new objj_ivar("_windowController"),new objj_ivar("_minSize"),new objj_ivar("_maxSize"),new objj_ivar("_undoManager"),new objj_ivar("_representedURL"),new objj_ivar("_registeredDraggedTypes"),new objj_ivar("_registeredDraggedTypesArray"),new objj_ivar("_inclusiveRegisteredDraggedTypes"),new objj_ivar("_defaultButton"),new objj_ivar("_defaultButtonEnabled"),new objj_ivar("_autorecalculatesKeyViewLoop"),new objj_ivar("_keyViewLoopIsDirty"),new objj_ivar("_sharesChromeWithPlatformWindow"),new objj_ivar("_autoresizingMask"),new objj_ivar("_delegateRespondsToWindowWillReturnUndoManagerSelector"),new objj_ivar("_isFullPlatformWindow"),new objj_ivar("_fullPlatformWindowSession"),new objj_ivar("_sheetContext"),new objj_ivar("_parentView"),new objj_ivar("_isSheet")]);
objj_registerClassPair(_9);
objj_addClassForBundle(_9,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_9,[new objj_method(sel_getUid("initWithContentRect:styleMask:"),function(_b,_c,_d,_e){
with(_b){
_b=objj_msgSendSuper({receiver:_b,super_class:objj_getClass("CPResponder")},"init");
if(_b){
var _f=objj_msgSend(objj_msgSend(_b,"class"),"_windowViewClassForStyleMask:",_e);
_frame=objj_msgSend(_f,"frameRectForContentRect:",_d);
objj_msgSend(_b,"_setSharesChromeWithPlatformWindow:",!objj_msgSend(CPPlatform,"isBrowser"));
if(objj_msgSend(CPPlatform,"isBrowser")){
objj_msgSend(_b,"setPlatformWindow:",objj_msgSend(CPPlatformWindow,"primaryPlatformWindow"));
}else{
objj_msgSend(_b,"setPlatformWindow:",objj_msgSend(objj_msgSend(CPPlatformWindow,"alloc"),"initWithContentRect:",_frame));
objj_msgSend(_b,"platformWindow")._only=_b;
}
_isFullPlatformWindow=NO;
_registeredDraggedTypes=objj_msgSend(CPSet,"set");
_registeredDraggedTypesArray=[];
_isSheet=NO;
_windowNumber=objj_msgSend(CPApp._windows,"count");
CPApp._windows[_windowNumber]=_b;
_styleMask=_e;
objj_msgSend(_b,"setLevel:",CPNormalWindowLevel);
_minSize=CGSizeMake(0,0);
_maxSize=CGSizeMake(1000000,1000000);
_windowView=objj_msgSend(objj_msgSend(_f,"alloc"),"initWithFrame:styleMask:",CGRectMake(0,0,CGRectGetWidth(_frame),CGRectGetHeight(_frame)),_e);
objj_msgSend(_windowView,"_setWindow:",_b);
objj_msgSend(_windowView,"setNextResponder:",_b);
objj_msgSend(_b,"setMovableByWindowBackground:",_e&CPHUDBackgroundWindowMask);
objj_msgSend(_b,"setContentView:",objj_msgSend(objj_msgSend(CPView,"alloc"),"initWithFrame:",CGRectMakeZero()));
_firstResponder=_b;
objj_msgSend(_b,"setNextResponder:",CPApp);
objj_msgSend(_b,"setHasShadow:",_e!==CPBorderlessWindowMask);
if(_e&CPBorderlessBridgeWindowMask){
objj_msgSend(_b,"setFullPlatformWindow:",YES);
}
_defaultButtonEnabled=YES;
_keyViewLoopIsDirty=YES;
}
return _b;
}
}),new objj_method(sel_getUid("platformWindow"),function(_10,_11){
with(_10){
return _platformWindow;
}
}),new objj_method(sel_getUid("setPlatformWindow:"),function(_12,_13,_14){
with(_12){
_platformWindow=_14;
}
}),new objj_method(sel_getUid("setSupportsMultipleDocuments:"),function(_15,_16,_17){
with(_15){
_17=!!_17;
_supportsMultipleDocuments=_17;
}
}),new objj_method(sel_getUid("supportsMultipleDocuments"),function(_18,_19){
with(_18){
return _supportsMultipleDocuments;
}
}),new objj_method(sel_getUid("awakeFromCib"),function(_1a,_1b){
with(_1a){
if(_initialFirstResponder){
objj_msgSend(_1a,"makeFirstResponder:",_initialFirstResponder);
}
_keyViewLoopIsDirty=!objj_msgSend(_1a,"_hasKeyViewLoop");
}
}),new objj_method(sel_getUid("_setWindowView:"),function(_1c,_1d,_1e){
with(_1c){
if(_windowView===_1e){
return;
}
var _1f=_windowView;
_windowView=_1e;
if(_1f){
objj_msgSend(_1f,"_setWindow:",nil);
objj_msgSend(_1f,"noteToolbarChanged");
}
if(_windowView){
var _20=objj_msgSend(_contentView,"convertRect:toView:",objj_msgSend(_contentView,"bounds"),nil);
_20.origin=objj_msgSend(_1c,"convertBaseToGlobal:",_20.origin);
objj_msgSend(_windowView,"_setWindow:",_1c);
objj_msgSend(_windowView,"setNextResponder:",_1c);
objj_msgSend(_windowView,"addSubview:",_contentView);
objj_msgSend(_windowView,"setTitle:",_title);
objj_msgSend(_windowView,"noteToolbarChanged");
objj_msgSend(_1c,"setFrame:",objj_msgSend(_1c,"frameRectForContentRect:",_20));
}
}
}),new objj_method(sel_getUid("setFullPlatformWindow:"),function(_21,_22,_23){
with(_21){
if(!objj_msgSend(_platformWindow,"supportsFullPlatformWindows")){
return;
}
_23=!!_23;
if(_isFullPlatformWindow===_23){
return;
}
_isFullPlatformWindow=_23;
if(_isFullPlatformWindow){
_fullPlatformWindowSession=_CPWindowFullPlatformWindowSessionMake(_windowView,objj_msgSend(_21,"contentRectForFrameRect:",objj_msgSend(_21,"frame")),objj_msgSend(_21,"hasShadow"),objj_msgSend(_21,"level"));
var _24=objj_msgSend(objj_msgSend(_21,"class"),"_windowViewClassForFullPlatformWindowStyleMask:",_styleMask),_25=objj_msgSend(objj_msgSend(_24,"alloc"),"initWithFrame:styleMask:",CGRectMakeZero(),_styleMask);
objj_msgSend(_21,"_setWindowView:",_25);
objj_msgSend(_21,"setLevel:",CPBackgroundWindowLevel);
objj_msgSend(_21,"setHasShadow:",NO);
objj_msgSend(_21,"setAutoresizingMask:",CPWindowWidthSizable|CPWindowHeightSizable);
objj_msgSend(_21,"setFrame:",objj_msgSend(_platformWindow,"visibleFrame"));
}else{
var _25=_fullPlatformWindowSession.windowView;
objj_msgSend(_21,"_setWindowView:",_25);
objj_msgSend(_21,"setLevel:",_fullPlatformWindowSession.level);
objj_msgSend(_21,"setHasShadow:",_fullPlatformWindowSession.hasShadow);
objj_msgSend(_21,"setAutoresizingMask:",CPWindowNotSizable);
objj_msgSend(_21,"setFrame:",objj_msgSend(_25,"frameRectForContentRect:",_fullPlatformWindowSession.contentRect));
}
}
}),new objj_method(sel_getUid("isFullPlatformWindow"),function(_26,_27){
with(_26){
return _isFullPlatformWindow;
}
}),new objj_method(sel_getUid("styleMask"),function(_28,_29){
with(_28){
return _styleMask;
}
}),new objj_method(sel_getUid("contentRectForFrameRect:"),function(_2a,_2b,_2c){
with(_2a){
return objj_msgSend(_windowView,"contentRectForFrameRect:",_2c);
}
}),new objj_method(sel_getUid("frameRectForContentRect:"),function(_2d,_2e,_2f){
with(_2d){
return objj_msgSend(_windowView,"frameRectForContentRect:",_2f);
}
}),new objj_method(sel_getUid("frame"),function(_30,_31){
with(_30){
return {origin:{x:_frame.origin.x,y:_frame.origin.y},size:{width:_frame.size.width,height:_frame.size.height}};
}
}),new objj_method(sel_getUid("setFrame:display:animate:"),function(_32,_33,_34,_35,_36){
with(_32){
if(_36){
var _37=objj_msgSend(objj_msgSend(_CPWindowFrameAnimation,"alloc"),"initWithWindow:targetFrame:",_32,_34);
objj_msgSend(_37,"startAnimation");
}else{
var _38=_frame.origin,_39=_34.origin;
if(!(_38.x==_39.x&&_38.y==_39.y)){
_38.x=_39.x;
_38.y=_39.y;
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowDidMoveNotification,_32);
}
var _3a=_frame.size,_3b=_34.size;
if(!(_3a.width==_3b.width&&_3a.height==_3b.height)){
_3a.width=MIN(MAX(_3b.width,_minSize.width),_maxSize.width);
_3a.height=MIN(MAX(_3b.height,_minSize.height),_maxSize.height);
objj_msgSend(_windowView,"setFrameSize:",_3a);
if(_hasShadow){
objj_msgSend(_shadowView,"setFrameSize:",{width:_1+_3a.width+_2,height:_4+_3a.height+_3+_5});
}
if(!_isAnimating&&objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowDidResize:"))){
objj_msgSend(_delegate,"windowDidResize:",_32);
}
}
if(objj_msgSend(_32,"_sharesChromeWithPlatformWindow")){
objj_msgSend(_platformWindow,"setContentRect:",_frame);
}
}
}
}),new objj_method(sel_getUid("setFrame:display:"),function(_3c,_3d,_3e,_3f){
with(_3c){
objj_msgSendSuper({receiver:_3c,super_class:objj_getClass("CPResponder")},"setFrame:display:animate:",_3e,_3f,NO);
}
}),new objj_method(sel_getUid("setFrame:"),function(_40,_41,_42){
with(_40){
objj_msgSend(_40,"setFrame:display:animate:",_42,YES,NO);
}
}),new objj_method(sel_getUid("setFrameOrigin:"),function(_43,_44,_45){
with(_43){
objj_msgSend(_43,"setFrame:display:animate:",{origin:{x:_45.x,y:_45.y},size:{width:(_frame.size.width),height:(_frame.size.height)}},YES,NO);
}
}),new objj_method(sel_getUid("setFrameSize:"),function(_46,_47,_48){
with(_46){
objj_msgSend(_46,"setFrame:display:animate:",{origin:{x:(_frame.origin.x),y:(_frame.origin.y)},size:{width:_48.width,height:_48.height}},YES,NO);
}
}),new objj_method(sel_getUid("orderFront:"),function(_49,_4a,_4b){
with(_49){
objj_msgSend(_platformWindow,"orderFront:",_49);
objj_msgSend(_platformWindow,"order:window:relativeTo:",CPWindowAbove,_49,nil);
}
}),new objj_method(sel_getUid("orderBack:"),function(_4c,_4d,_4e){
with(_4c){
}
}),new objj_method(sel_getUid("orderOut:"),function(_4f,_50,_51){
with(_4f){
if(objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowWillClose:"))){
objj_msgSend(_delegate,"windowWillClose:",_4f);
}
objj_msgSend(_platformWindow,"order:window:relativeTo:",CPWindowOut,_4f,nil);
if(objj_msgSend(CPApp,"keyWindow")==_4f){
objj_msgSend(_4f,"resignKeyWindow");
CPApp._keyWindow=nil;
}
if(objj_msgSend(_4f,"_sharesChromeWithPlatformWindow")){
objj_msgSend(_platformWindow,"orderOut:",_4f);
}
}
}),new objj_method(sel_getUid("orderWindow:relativeTo:"),function(_52,_53,_54,_55){
with(_52){
objj_msgSend(_platformWindow,"order:window:relativeTo:",_54,_52,CPApp._windows[_55]);
}
}),new objj_method(sel_getUid("setLevel:"),function(_56,_57,_58){
with(_56){
_level=_58;
if(objj_msgSend(_56,"_sharesChromeWithPlatformWindow")){
objj_msgSend(_platformWindow,"setLevel:",_58);
}
}
}),new objj_method(sel_getUid("level"),function(_59,_5a){
with(_59){
return _level;
}
}),new objj_method(sel_getUid("isVisible"),function(_5b,_5c){
with(_5b){
return _isVisible;
}
}),new objj_method(sel_getUid("showsResizeIndicator"),function(_5d,_5e){
with(_5d){
return objj_msgSend(_windowView,"showsResizeIndicator");
}
}),new objj_method(sel_getUid("setShowsResizeIndicator:"),function(_5f,_60,_61){
with(_5f){
objj_msgSend(_windowView,"setShowsResizeIndicator:",_61);
}
}),new objj_method(sel_getUid("resizeIndicatorOffset"),function(_62,_63){
with(_62){
return objj_msgSend(_windowView,"resizeIndicatorOffset");
}
}),new objj_method(sel_getUid("setResizeIndicatorOffset:"),function(_64,_65,_66){
with(_64){
objj_msgSend(_windowView,"setResizeIndicatorOffset:",_66);
}
}),new objj_method(sel_getUid("setContentView:"),function(_67,_68,_69){
with(_67){
if(_contentView){
objj_msgSend(_contentView,"removeFromSuperview");
}
var _6a=CGRectMake(0,0,CGRectGetWidth(_frame),CGRectGetHeight(_frame));
_contentView=_69;
objj_msgSend(_contentView,"setFrame:",objj_msgSend(_67,"contentRectForFrameRect:",_6a));
objj_msgSend(_contentView,"setAutoresizingMask:",CPViewWidthSizable|CPViewHeightSizable);
objj_msgSend(_windowView,"addSubview:",_contentView);
}
}),new objj_method(sel_getUid("contentView"),function(_6b,_6c){
with(_6b){
return _contentView;
}
}),new objj_method(sel_getUid("setBackgroundColor:"),function(_6d,_6e,_6f){
with(_6d){
objj_msgSend(_windowView,"setBackgroundColor:",_6f);
}
}),new objj_method(sel_getUid("backgroundColor"),function(_70,_71){
with(_70){
return objj_msgSend(_windowView,"backgroundColor");
}
}),new objj_method(sel_getUid("setMinSize:"),function(_72,_73,_74){
with(_72){
if(CGSizeEqualToSize(_minSize,_74)){
return;
}
_minSize=CGSizeCreateCopy(_74);
var _75=CGSizeMakeCopy(objj_msgSend(_72,"frame").size),_76=NO;
if(_75.width<_minSize.width){
_75.width=_minSize.width;
_76=YES;
}
if(_75.height<_minSize.height){
_75.height=_minSize.height;
_76=YES;
}
if(_76){
objj_msgSend(_72,"setFrameSize:",_75);
}
}
}),new objj_method(sel_getUid("minSize"),function(_77,_78){
with(_77){
return _minSize;
}
}),new objj_method(sel_getUid("setMaxSize:"),function(_79,_7a,_7b){
with(_79){
if(CGSizeEqualToSize(_maxSize,_7b)){
return;
}
_maxSize=CGSizeCreateCopy(_7b);
var _7c=CGSizeMakeCopy(objj_msgSend(_79,"frame").size),_7d=NO;
if(_7c.width>_maxSize.width){
_7c.width=_maxSize.width;
_7d=YES;
}
if(_7c.height>_maxSize.height){
_7c.height=_maxSize.height;
_7d=YES;
}
if(_7d){
objj_msgSend(_79,"setFrameSize:",_7c);
}
}
}),new objj_method(sel_getUid("maxSize"),function(_7e,_7f){
with(_7e){
return _maxSize;
}
}),new objj_method(sel_getUid("hasShadow"),function(_80,_81){
with(_80){
return _hasShadow;
}
}),new objj_method(sel_getUid("setHasShadow:"),function(_82,_83,_84){
with(_82){
if(_hasShadow===_84){
return;
}
_hasShadow=_84;
if(objj_msgSend(_82,"_sharesChromeWithPlatformWindow")){
return objj_msgSend(_platformWindow,"setHasShadow:",_84);
}
if(_hasShadow){
var _85=objj_msgSend(_windowView,"bounds");
_shadowView=objj_msgSend(objj_msgSend(CPView,"alloc"),"initWithFrame:",CGRectMake(-_1,-_3+_5,_1+CGRectGetWidth(_85)+_2,_3+CGRectGetHeight(_85)+_4));
if(!_6){
var _86=objj_msgSend(CPBundle,"bundleForClass:",objj_msgSend(CPWindow,"class"));
_6=objj_msgSend(CPColor,"colorWithPatternImage:",objj_msgSend(objj_msgSend(CPNinePartImage,"alloc"),"initWithImageSlices:",[objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow0.png"),CGSizeMake(20,19)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow1.png"),CGSizeMake(1,19)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow2.png"),CGSizeMake(19,19)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow3.png"),CGSizeMake(20,1)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow4.png"),CGSizeMake(1,1)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow5.png"),CGSizeMake(19,1)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow6.png"),CGSizeMake(20,18)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow7.png"),CGSizeMake(1,18)),objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_86,"pathForResource:","CPWindow/CPWindowShadow8.png"),CGSizeMake(19,18))]));
}
objj_msgSend(_shadowView,"setBackgroundColor:",_6);
objj_msgSend(_shadowView,"setAutoresizingMask:",CPViewWidthSizable|CPViewHeightSizable);
}else{
if(_shadowView){
_shadowView=nil;
}
}
}
}),new objj_method(sel_getUid("setShadowStyle:"),function(_87,_88,_89){
with(_87){
_shadowStyle=_89;
objj_msgSend(objj_msgSend(_87,"platformWindow"),"setShadowStyle:",_shadowStyle);
}
}),new objj_method(sel_getUid("setDelegate:"),function(_8a,_8b,_8c){
with(_8a){
_delegate=_8c;
_delegateRespondsToWindowWillReturnUndoManagerSelector=objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowWillReturnUndoManager:"));
var _8d=objj_msgSend(CPNotificationCenter,"defaultCenter");
if(objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowDidBecomeMain:"))){
objj_msgSend(_8d,"addObserver:selector:name:object:",_delegate,sel_getUid("windowDidBecomeMain:"),CPWindowDidBecomeMainNotification,_8a);
}
if(objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowDidResignMain:"))){
objj_msgSend(_8d,"addObserver:selector:name:object:",_delegate,sel_getUid("windowDidResignMain:"),CPWindowDidResignMainNotification,_8a);
}
if(objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowDidMove:"))){
objj_msgSend(_8d,"addObserver:selector:name:object:",_delegate,sel_getUid("windowDidMove:"),CPWindowDidMoveNotification,_8a);
}
}
}),new objj_method(sel_getUid("delegate"),function(_8e,_8f){
with(_8e){
return _delegate;
}
}),new objj_method(sel_getUid("setWindowController:"),function(_90,_91,_92){
with(_90){
_windowController=_92;
}
}),new objj_method(sel_getUid("windowController"),function(_93,_94){
with(_93){
return _windowController;
}
}),new objj_method(sel_getUid("doCommandBySelector:"),function(_95,_96,_97){
with(_95){
if(objj_msgSend(_delegate,"respondsToSelector:",_97)){
objj_msgSend(_delegate,"performSelector:",_97);
}else{
objj_msgSendSuper({receiver:_95,super_class:objj_getClass("CPResponder")},"doCommandBySelector:",_97);
}
}
}),new objj_method(sel_getUid("acceptsFirstResponder"),function(_98,_99){
with(_98){
return YES;
}
}),new objj_method(sel_getUid("makeFirstResponder:"),function(_9a,_9b,_9c){
with(_9a){
if(_firstResponder==_9c){
return YES;
}
if(!objj_msgSend(_firstResponder,"resignFirstResponder")){
return NO;
}
if(!_9c||!objj_msgSend(_9c,"acceptsFirstResponder")||!objj_msgSend(_9c,"becomeFirstResponder")){
_firstResponder=_9a;
return NO;
}
_firstResponder=_9c;
return YES;
}
}),new objj_method(sel_getUid("firstResponder"),function(_9d,_9e){
with(_9d){
return _firstResponder;
}
}),new objj_method(sel_getUid("acceptsMouseMovedEvents"),function(_9f,_a0){
with(_9f){
return _acceptsMouseMovedEvents;
}
}),new objj_method(sel_getUid("setAcceptsMouseMovedEvents:"),function(_a1,_a2,_a3){
with(_a1){
_acceptsMouseMovedEvents=_a3;
}
}),new objj_method(sel_getUid("ignoresMouseEvents"),function(_a4,_a5){
with(_a4){
return _ignoresMouseEvents;
}
}),new objj_method(sel_getUid("setIgnoresMouseEvents:"),function(_a6,_a7,_a8){
with(_a6){
_ignoresMouseEvents=_a8;
}
}),new objj_method(sel_getUid("title"),function(_a9,_aa){
with(_a9){
return _title;
}
}),new objj_method(sel_getUid("setTitle:"),function(_ab,_ac,_ad){
with(_ab){
_title=_ad;
objj_msgSend(_windowView,"setTitle:",_ad);
objj_msgSend(_ab,"_synchronizeMenuBarTitleWithWindowTitle");
}
}),new objj_method(sel_getUid("setTitleWithRepresentedFilename:"),function(_ae,_af,_b0){
with(_ae){
objj_msgSend(_ae,"setRepresentedFilename:",_b0);
objj_msgSend(_ae,"setTitle:",objj_msgSend(_b0,"lastPathComponent"));
}
}),new objj_method(sel_getUid("setRepresentedFilename:"),function(_b1,_b2,_b3){
with(_b1){
objj_msgSend(_b1,"setRepresentedURL:",_b3);
}
}),new objj_method(sel_getUid("representedFilename"),function(_b4,_b5){
with(_b4){
return _representedURL;
}
}),new objj_method(sel_getUid("setRepresentedURL:"),function(_b6,_b7,_b8){
with(_b6){
_representedURL=_b8;
}
}),new objj_method(sel_getUid("representedURL"),function(_b9,_ba){
with(_b9){
return _representedURL;
}
}),new objj_method(sel_getUid("screen"),function(_bb,_bc){
with(_bb){
return objj_msgSend(objj_msgSend(CPScreen,"alloc"),"init");
}
}),new objj_method(sel_getUid("setMovableByWindowBackground:"),function(_bd,_be,_bf){
with(_bd){
_isMovableByWindowBackground=_bf;
}
}),new objj_method(sel_getUid("isMovableByWindowBackground"),function(_c0,_c1){
with(_c0){
return _isMovableByWindowBackground;
}
}),new objj_method(sel_getUid("center"),function(_c2,_c3){
with(_c2){
var _c4=objj_msgSend(_c2,"frame").size,_c5=objj_msgSend(CPPlatform,"isBrowser")?objj_msgSend(_platformWindow,"contentBounds").size:objj_msgSend(objj_msgSend(_c2,"screen"),"visibleFrame").size;
objj_msgSend(_c2,"setFrameOrigin:",CGPointMake((_c5.width-_c4.width)/2,(_c5.height-_c4.height)/2));
}
}),new objj_method(sel_getUid("sendEvent:"),function(_c6,_c7,_c8){
with(_c6){
var _c9=objj_msgSend(_c8,"type"),_ca=objj_msgSend(_c8,"locationInWindow");
switch(_c9){
case CPKeyUp:
return objj_msgSend(objj_msgSend(_c6,"firstResponder"),"keyUp:",_c8);
case CPKeyDown:
return objj_msgSend(objj_msgSend(_c6,"firstResponder"),"keyDown:",_c8);
case CPScrollWheel:
return objj_msgSend(objj_msgSend(_windowView,"hitTest:",_ca),"scrollWheel:",_c8);
case CPLeftMouseUp:
if(!_leftMouseDownView){
return objj_msgSend(objj_msgSend(_windowView,"hitTest:",_ca),"mouseUp:",_c8);
}
objj_msgSend(_leftMouseDownView,"mouseUp:",_c8);
_leftMouseDownView=nil;
return;
case CPLeftMouseDown:
_leftMouseDownView=objj_msgSend(_windowView,"hitTest:",_ca);
if(_leftMouseDownView!=_firstResponder&&objj_msgSend(_leftMouseDownView,"acceptsFirstResponder")){
objj_msgSend(_c6,"makeFirstResponder:",_leftMouseDownView);
}
var _cb=objj_msgSend(_c8,"window");
if(objj_msgSend(_cb,"isKeyWindow")||objj_msgSend(_cb,"becomesKeyOnlyIfNeeded")){
return objj_msgSend(_leftMouseDownView,"mouseDown:",_c8);
}else{
objj_msgSend(_c6,"makeKeyAndOrderFront:",_c6);
if(objj_msgSend(_leftMouseDownView,"acceptsFirstMouse:",_c8)){
return objj_msgSend(_leftMouseDownView,"mouseDown:",_c8);
}
}
break;
case CPLeftMouseDragged:
if(!_leftMouseDownView){
return objj_msgSend(objj_msgSend(_windowView,"hitTest:",_ca),"mouseDragged:",_c8);
}
return objj_msgSend(_leftMouseDownView,"mouseDragged:",_c8);
case CPRightMouseUp:
return objj_msgSend(_rightMouseDownView,"mouseUp:",_c8);
case CPRightMouseDown:
_rightMouseDownView=objj_msgSend(_windowView,"hitTest:",_ca);
return objj_msgSend(_rightMouseDownView,"mouseDown:",_c8);
case CPRightMouseDragged:
return objj_msgSend(_rightMouseDownView,"mouseDragged:",_c8);
case CPMouseMoved:
if(!_acceptsMouseMovedEvents){
return;
}
if(!_mouseEnteredStack){
_mouseEnteredStack=[];
}
var _cc=objj_msgSend(_windowView,"hitTest:",_ca);
if(objj_msgSend(_mouseEnteredStack,"count")&&objj_msgSend(_mouseEnteredStack,"lastObject")===_cc){
return objj_msgSend(_cc,"mouseMoved:",_c8);
}
var _cd=_cc,_ce=[];
while(_cd){
_ce.unshift(_cd);
_cd=objj_msgSend(_cd,"superview");
}
var _cf=MIN(_mouseEnteredStack.length,_ce.length);
while(_cf--){
if(_mouseEnteredStack[_cf]===_ce[_cf]){
break;
}
}
var _d0=_cf+1,_d1=_mouseEnteredStack.length;
if(_d0<_d1){
var _d2=objj_msgSend(CPEvent,"mouseEventWithType:location:modifierFlags:timestamp:windowNumber:context:eventNumber:clickCount:pressure:",CPMouseExited,_ca,objj_msgSend(_c8,"modifierFlags"),objj_msgSend(_c8,"timestamp"),_windowNumber,nil,-1,1,0);
for(;_d0<_d1;++_d0){
objj_msgSend(_mouseEnteredStack[_d0],"mouseExited:",_d2);
}
}
_d0=_cf+1;
_d1=_ce.length;
if(_d0<_d1){
var _d2=objj_msgSend(CPEvent,"mouseEventWithType:location:modifierFlags:timestamp:windowNumber:context:eventNumber:clickCount:pressure:",CPMouseEntered,_ca,objj_msgSend(_c8,"modifierFlags"),objj_msgSend(_c8,"timestamp"),_windowNumber,nil,-1,1,0);
for(;_d0<_d1;++_d0){
objj_msgSend(_ce[_d0],"mouseEntered:",_d2);
}
}
_mouseEnteredStack=_ce;
objj_msgSend(_cc,"mouseMoved:",_c8);
}
}
}),new objj_method(sel_getUid("windowNumber"),function(_d3,_d4){
with(_d3){
return _windowNumber;
}
}),new objj_method(sel_getUid("becomeKeyWindow"),function(_d5,_d6){
with(_d5){
if(_firstResponder!=_d5&&objj_msgSend(_firstResponder,"respondsToSelector:",sel_getUid("becomeKeyWindow"))){
objj_msgSend(_firstResponder,"becomeKeyWindow");
}
}
}),new objj_method(sel_getUid("canBecomeKeyWindow"),function(_d7,_d8){
with(_d7){
return YES;
}
}),new objj_method(sel_getUid("isKeyWindow"),function(_d9,_da){
with(_d9){
return objj_msgSend(CPApp,"keyWindow")==_d9;
}
}),new objj_method(sel_getUid("makeKeyAndOrderFront:"),function(_db,_dc,_dd){
with(_db){
objj_msgSend(_db,"orderFront:",_db);
objj_msgSend(_db,"makeKeyWindow");
objj_msgSend(_db,"makeMainWindow");
}
}),new objj_method(sel_getUid("makeKeyWindow"),function(_de,_df){
with(_de){
if(!objj_msgSend(_de,"canBecomeKeyWindow")){
return;
}
objj_msgSend(CPApp._keyWindow,"resignKeyWindow");
CPApp._keyWindow=_de;
objj_msgSend(_de,"becomeKeyWindow");
}
}),new objj_method(sel_getUid("resignKeyWindow"),function(_e0,_e1){
with(_e0){
if(_firstResponder!=_e0&&objj_msgSend(_firstResponder,"respondsToSelector:",sel_getUid("resignKeyWindow"))){
objj_msgSend(_firstResponder,"resignKeyWindow");
}
if(objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowDidResignKey:"))){
objj_msgSend(_delegate,"windowDidResignKey:",_e0);
}
}
}),new objj_method(sel_getUid("dragImage:at:offset:event:pasteboard:source:slideBack:"),function(_e2,_e3,_e4,_e5,_e6,_e7,_e8,_e9,_ea){
with(_e2){
objj_msgSend(objj_msgSend(CPDragServer,"sharedDragServer"),"dragImage:fromWindow:at:offset:event:pasteboard:source:slideBack:",_e4,_e2,objj_msgSend(_e2,"convertBaseToGlobal:",_e5),_e6,_e7,_e8,_e9,_ea);
}
}),new objj_method(sel_getUid("_noteRegisteredDraggedTypes:"),function(_eb,_ec,_ed){
with(_eb){
if(!_ed){
return;
}
if(!_inclusiveRegisteredDraggedTypes){
_inclusiveRegisteredDraggedTypes=objj_msgSend(CPCountedSet,"set");
}
objj_msgSend(_inclusiveRegisteredDraggedTypes,"unionSet:",_ed);
}
}),new objj_method(sel_getUid("_noteUnregisteredDraggedTypes:"),function(_ee,_ef,_f0){
with(_ee){
if(!_f0){
return;
}
objj_msgSend(_inclusiveRegisteredDraggedTypes,"minusSet:",_f0);
if(objj_msgSend(_inclusiveRegisteredDraggedTypes,"count")===0){
_inclusiveRegisteredDraggedTypes=nil;
}
}
}),new objj_method(sel_getUid("dragView:at:offset:event:pasteboard:source:slideBack:"),function(_f1,_f2,_f3,_f4,_f5,_f6,_f7,_f8,_f9){
with(_f1){
objj_msgSend(objj_msgSend(CPDragServer,"sharedDragServer"),"dragView:fromWindow:at:offset:event:pasteboard:source:slideBack:",_f3,_f1,objj_msgSend(_f1,"convertBaseToGlobal:",_f4),_f5,_f6,_f7,_f8,_f9);
}
}),new objj_method(sel_getUid("registerForDraggedTypes:"),function(_fa,_fb,_fc){
with(_fa){
if(!_fc){
return;
}
objj_msgSend(_fa,"_noteUnregisteredDraggedTypes:",_registeredDraggedTypes);
objj_msgSend(_registeredDraggedTypes,"addObjectsFromArray:",_fc);
objj_msgSend(_fa,"_noteRegisteredDraggedTypes:",_registeredDraggedTypes);
_registeredDraggedTypesArray=nil;
}
}),new objj_method(sel_getUid("registeredDraggedTypes"),function(_fd,_fe){
with(_fd){
if(!_registeredDraggedTypesArray){
_registeredDraggedTypesArray=objj_msgSend(_registeredDraggedTypes,"allObjects");
}
return _registeredDraggedTypesArray;
}
}),new objj_method(sel_getUid("unregisterDraggedTypes"),function(_ff,_cmd){
with(_ff){
objj_msgSend(_ff,"_noteUnregisteredDraggedTypes:",_registeredDraggedTypes);
_registeredDraggedTypes=objj_msgSend(CPSet,"set");
_registeredDraggedTypesArray=[];
}
}),new objj_method(sel_getUid("setDocumentEdited:"),function(self,_cmd,_103){
with(self){
if(_isDocumentEdited==_103){
return;
}
_isDocumentEdited=_103;
objj_msgSend(CPMenu,"_setMenuBarIconImageAlphaValue:",_isDocumentEdited?0.5:1);
}
}),new objj_method(sel_getUid("isDocumentEdited"),function(self,_cmd){
with(self){
return _isDocumentEdited;
}
}),new objj_method(sel_getUid("setDocumentSaving:"),function(self,_cmd,_108){
with(self){
if(_isDocumentSaving==_108){
return;
}
_isDocumentSaving=_108;
objj_msgSend(self,"_synchronizeSaveMenuWithDocumentSaving");
objj_msgSend(_windowView,"windowDidChangeDocumentSaving");
}
}),new objj_method(sel_getUid("isDocumentSaving"),function(self,_cmd){
with(self){
return _isDocumentSaving;
}
}),new objj_method(sel_getUid("_synchronizeSaveMenuWithDocumentSaving"),function(self,_cmd){
with(self){
if(!objj_msgSend(self,"isMainWindow")){
return;
}
var _10d=objj_msgSend(CPApp,"mainMenu"),_10e=objj_msgSend(_10d,"indexOfItemWithTitle:",_isDocumentSaving?"Save":"Saving...");
if(_10e==CPNotFound){
return;
}
var item=objj_msgSend(_10d,"itemAtIndex:",_10e);
if(_isDocumentSaving){
_7=objj_msgSend(item,"image");
objj_msgSend(item,"setTitle:","Saving...");
objj_msgSend(item,"setImage:",_8);
objj_msgSend(item,"setEnabled:",NO);
}else{
objj_msgSend(item,"setTitle:","Save");
objj_msgSend(item,"setImage:",_7);
objj_msgSend(item,"setEnabled:",YES);
}
}
}),new objj_method(sel_getUid("performMiniaturize:"),function(self,_cmd,_112){
with(self){
objj_msgSend(self,"miniaturize:",_112);
}
}),new objj_method(sel_getUid("miniaturize:"),function(self,_cmd,_115){
with(self){
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowWillMiniaturizeNotification,self);
objj_msgSend(objj_msgSend(self,"platformWindow"),"miniaturize:",_115);
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowDidMiniaturizeNotification,self);
_isMiniaturized=YES;
}
}),new objj_method(sel_getUid("deminiaturize:"),function(self,_cmd,_118){
with(self){
objj_msgSend(objj_msgSend(self,"platformWindow"),"deminiaturize:",_118);
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowDidDeminiaturizeNotification,self);
_isMiniaturized=NO;
}
}),new objj_method(sel_getUid("isMiniaturized"),function(self,_cmd){
with(self){
return _isMiniaturized;
}
}),new objj_method(sel_getUid("performClose:"),function(self,_cmd,_11d){
with(self){
if(objj_msgSend(_delegate,"respondsToSelector:",sel_getUid("windowShouldClose:"))){
if(!objj_msgSend(_delegate,"windowShouldClose:",self)){
return;
}
}else{
if(objj_msgSend(self,"respondsToSelector:",sel_getUid("windowShouldClose:"))&&!objj_msgSend(self,"windowShouldClose:",self)){
return;
}
}
objj_msgSend(self,"close");
}
}),new objj_method(sel_getUid("close"),function(self,_cmd){
with(self){
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowWillCloseNotification,self);
objj_msgSend(self,"orderOut:",nil);
}
}),new objj_method(sel_getUid("isMainWindow"),function(self,_cmd){
with(self){
return objj_msgSend(CPApp,"mainWindow")==self;
}
}),new objj_method(sel_getUid("canBecomeMainWindow"),function(self,_cmd){
with(self){
if(objj_msgSend(self,"isVisible")){
return YES;
}
return NO;
}
}),new objj_method(sel_getUid("makeMainWindow"),function(self,_cmd){
with(self){
if(!objj_msgSend(self,"canBecomeMainWindow")){
return;
}
objj_msgSend(CPApp._mainWindow,"resignMainWindow");
CPApp._mainWindow=self;
objj_msgSend(self,"becomeMainWindow");
}
}),new objj_method(sel_getUid("becomeMainWindow"),function(self,_cmd){
with(self){
objj_msgSend(self,"_synchronizeMenuBarTitleWithWindowTitle");
objj_msgSend(self,"_synchronizeSaveMenuWithDocumentSaving");
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowDidBecomeMainNotification,self);
}
}),new objj_method(sel_getUid("resignMainWindow"),function(self,_cmd){
with(self){
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowDidResignMainNotification,self);
}
}),new objj_method(sel_getUid("toolbar"),function(self,_cmd){
with(self){
return _toolbar;
}
}),new objj_method(sel_getUid("setToolbar:"),function(self,_cmd,_12e){
with(self){
if(_toolbar===_12e){
return;
}
objj_msgSend(objj_msgSend(_12e,"_window"),"setToolbar:",nil);
objj_msgSend(_toolbar,"_setWindow:",nil);
_toolbar=_12e;
objj_msgSend(_toolbar,"_setWindow:",self);
objj_msgSend(self,"_noteToolbarChanged");
}
}),new objj_method(sel_getUid("toggleToolbarShown:"),function(self,_cmd,_131){
with(self){
var _132=objj_msgSend(self,"toolbar");
objj_msgSend(_132,"setVisible:",!objj_msgSend(_132,"isVisible"));
}
}),new objj_method(sel_getUid("_noteToolbarChanged"),function(self,_cmd){
with(self){
var _135=CGRectMakeCopy(objj_msgSend(self,"frame")),_136;
objj_msgSend(_windowView,"noteToolbarChanged");
if(_isFullPlatformWindow){
_136=objj_msgSend(_platformWindow,"visibleFrame");
}else{
_136=CGRectMakeCopy(objj_msgSend(self,"frame"));
_136.origin=_135.origin;
}
objj_msgSend(self,"setFrame:",_136);
}
}),new objj_method(sel_getUid("_setFrame:delegate:duration:curve:"),function(self,_cmd,_139,_13a,_13b,_13c){
with(self){
var _13d=objj_msgSend(objj_msgSend(_CPWindowFrameAnimation,"alloc"),"initWithWindow:targetFrame:",self,_139);
objj_msgSend(_13d,"setDelegate:",_13a);
objj_msgSend(_13d,"setAnimationCurve:",_13c);
objj_msgSend(_13d,"setDuration:",_13b);
objj_msgSend(_13d,"startAnimation");
}
}),new objj_method(sel_getUid("_setAttachedSheetFrameOrigin"),function(self,_cmd){
with(self){
var _140=objj_msgSend(self,"attachedSheet");
var _141=objj_msgSend(objj_msgSend(self,"contentView"),"frame"),_142=CGRectMakeCopy(objj_msgSend(_140,"frame"));
_142.origin.y=CGRectGetMinY(_frame)+CGRectGetMinY(_141);
_142.origin.x=CGRectGetMinX(_frame)+FLOOR((CGRectGetWidth(_frame)-CGRectGetWidth(_142))/2);
objj_msgSend(_140,"setFrameOrigin:",_142.origin);
}
}),new objj_method(sel_getUid("_attachSheet:modalDelegate:didEndSelector:contextInfo:"),function(self,_cmd,_145,_146,_147,_148){
with(self){
var _149=objj_msgSend(_145,"frame");
_sheetContext={"sheet":_145,"modalDelegate":_146,"endSelector":_147,"contextInfo":_148,"frame":CGRectMakeCopy(_149),"returnCode":-1,"opened":NO};
objj_msgSend(self,"_attachSheetWindow:",_145);
}
}),new objj_method(sel_getUid("_attachSheetWindow:"),function(self,_cmd,_14c){
with(self){
var _14d=objj_msgSend(_14c,"frame"),_14e=objj_msgSend(self,"frame"),_14f=objj_msgSend(_14c,"contentView");
objj_msgSend(self,"_setUpMasksForView:",_14f);
_14c._isSheet=YES;
_14c._parentView=self;
var _150=_14e.origin.x+FLOOR((_14e.size.width-_14d.size.width)/2),_151=_14e.origin.y+objj_msgSend(objj_msgSend(self,"contentView"),"frame").origin.y,_152=CGRectMake(_150,_151,_14d.size.width,0),_153=CGRectMake(_150,_151,_14d.size.width,_14d.size.height);
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowWillBeginSheetNotification,self);
objj_msgSend(CPApp,"runModalForWindow:",_14c);
objj_msgSend(_14c,"orderFront:",self);
objj_msgSend(_14c,"setFrame:",_152);
_sheetContext["opened"]=YES;
objj_msgSend(_14c,"_setFrame:delegate:duration:curve:",_153,self,0.2,CPAnimationEaseOut);
objj_msgSend(_14c,"becomeKeyWindow");
}
}),new objj_method(sel_getUid("_detachSheetWindow"),function(self,_cmd){
with(self){
var _156=objj_msgSend(self,"attachedSheet"),_157=objj_msgSend(_156,"frame"),_158=CGRectMakeCopy(_157);
_158.size.height=0;
_sheetContext["frame"]=_157;
var _159=objj_msgSend(_156,"contentView");
objj_msgSend(self,"_setUpMasksForView:",_159);
_sheetContext["opened"]=NO;
objj_msgSend(_156,"_setFrame:delegate:duration:curve:",_158,self,0.2,CPAnimationEaseIn);
}
}),new objj_method(sel_getUid("animationDidEnd:"),function(self,_cmd,anim){
with(self){
var _15d=_sheetContext["sheet"];
if(anim._window!=_15d){
return;
}
var _15e=objj_msgSend(_15d,"contentView");
if(_sheetContext["opened"]===YES){
objj_msgSend(self,"_restoreMasksForView:",_15e);
return;
}
objj_msgSend(CPApp,"stopModal");
objj_msgSend(objj_msgSend(CPNotificationCenter,"defaultCenter"),"postNotificationName:object:",CPWindowDidEndSheetNotification,self);
objj_msgSend(_15d,"orderOut:",self);
var _15f=_sheetContext["frame"];
objj_msgSend(_15d,"setFrame:",_15f);
objj_msgSend(self,"_restoreMasksForView:",_15e);
var _160=_sheetContext["modalDelegate"],_161=_sheetContext["endSelector"];
if(_160!=nil&&_161!=nil){
objj_msgSend(_160,_161,_15d,_sheetContext["returnCode"],_sheetContext["contextInfo"]);
}
_sheetContext=nil;
_15d._parentView=nil;
}
}),new objj_method(sel_getUid("_setUpMasksForView:"),function(self,_cmd,_164){
with(self){
var _165=objj_msgSend(CPArray,"arrayWithArray:",objj_msgSend(_164,"subviews"));
objj_msgSend(_165,"addObject:",_164);
for(var i=0,_167=objj_msgSend(_165,"count");i<_167;i++){
var view=objj_msgSend(_165,"objectAtIndex:",i),mask=objj_msgSend(view,"autoresizingMask"),_16a=(mask&CPViewMinYMargin)?128:CPViewMinYMargin;
objj_msgSend(view,"setAutoresizingMask:",(mask|_16a));
}
}
}),new objj_method(sel_getUid("_restoreMasksForView:"),function(self,_cmd,_16d){
with(self){
var _16e=objj_msgSend(CPArray,"arrayWithArray:",objj_msgSend(_16d,"subviews"));
objj_msgSend(_16e,"addObject:",_16d);
for(var i=0,_170=objj_msgSend(_16e,"count");i<_170;i++){
var view=objj_msgSend(_16e,"objectAtIndex:",i),mask=objj_msgSend(view,"autoresizingMask"),_173=(mask&128)?128:CPViewMinYMargin;
objj_msgSend(view,"setAutoresizingMask:",(mask&(~_173)));
}
}
}),new objj_method(sel_getUid("attachedSheet"),function(self,_cmd){
with(self){
if(_sheetContext===nil){
return nil;
}
return _sheetContext["sheet"];
}
}),new objj_method(sel_getUid("isSheet"),function(self,_cmd){
with(self){
return _isSheet;
}
}),new objj_method(sel_getUid("becomesKeyOnlyIfNeeded"),function(self,_cmd){
with(self){
return NO;
}
}),new objj_method(sel_getUid("worksWhenModal"),function(self,_cmd){
with(self){
return NO;
}
}),new objj_method(sel_getUid("keyDown:"),function(self,_cmd,_17e){
with(self){
if(!objj_msgSend(self,"performKeyEquivalent:",_17e)){
objj_msgSend(self,"interpretKeyEvents:",[_17e]);
}
}
}),new objj_method(sel_getUid("insertNewline:"),function(self,_cmd,_181){
with(self){
if(_defaultButton&&_defaultButtonEnabled){
objj_msgSend(_defaultButton,"performClick:",nil);
}
}
}),new objj_method(sel_getUid("insertTab:"),function(self,_cmd,_184){
with(self){
objj_msgSend(self,"selectNextKeyView:",nil);
}
}),new objj_method(sel_getUid("_dirtyKeyViewLoop"),function(self,_cmd){
with(self){
if(_autorecalculatesKeyViewLoop){
_keyViewLoopIsDirty=YES;
}
}
}),new objj_method(sel_getUid("_hasKeyViewLoop"),function(self,_cmd){
with(self){
var _189=[];
objj_msgSend(self,"_appendSubviewsOf:toArray:",_contentView,_189);
for(var i=0,_18b=objj_msgSend(_189,"count");i<_18b;i++){
if(_189[i]._nextKeyView){
return YES;
}
}
return NO;
}
}),new objj_method(sel_getUid("recalculateKeyViewLoop"),function(self,_cmd){
with(self){
var _18e=[];
objj_msgSend(self,"_appendSubviewsOf:toArray:",_contentView,_18e);
var _18f=objj_msgSend(_18e,"sortedArrayUsingFunction:context:",_190,_contentView),_191=objj_msgSend(_18f,"count");
for(var i=0;i<_191;i++){
objj_msgSend(_18f[i],"setNextKeyView:",_18f[(i+1)%_191]);
}
_keyViewLoopIsDirty=NO;
}
}),new objj_method(sel_getUid("_appendSubviewsOf:toArray:"),function(self,_cmd,_195,_196){
with(self){
var _197=objj_msgSend(_195,"subviews"),_198=objj_msgSend(_197,"count");
while(_198--){
objj_msgSend(self,"_appendSubviewsOf:toArray:",_197[_198],_196);
}
objj_msgSend(_196,"addObject:",_195);
}
}),new objj_method(sel_getUid("setAutorecalculatesKeyViewLoop:"),function(self,_cmd,_19b){
with(self){
if(_autorecalculatesKeyViewLoop===_19b){
return;
}
_autorecalculatesKeyViewLoop=_19b;
if(_keyViewLoopIsDirty){
objj_msgSend(self,"recalculateKeyViewLoop");
}else{
if(_autorecalculatesKeyViewLoop){
objj_msgSend(self,"_dirtyKeyViewLoop");
}
}
}
}),new objj_method(sel_getUid("autorecalculatesKeyViewLoop"),function(self,_cmd){
with(self){
return _autorecalculatesKeyViewLoop;
}
}),new objj_method(sel_getUid("selectNextKeyView:"),function(self,_cmd,_1a0){
with(self){
if(objj_msgSend(_firstResponder,"isKindOfClass:",objj_msgSend(CPView,"class"))){
objj_msgSend(self,"selectKeyViewFollowingView:",_firstResponder);
}
}
}),new objj_method(sel_getUid("selectPreviousKeyView:"),function(self,_cmd,_1a3){
with(self){
if(objj_msgSend(_firstResponder,"isKindOfClass:",objj_msgSend(CPView,"class"))){
objj_msgSend(self,"selectKeyViewPrecedingView:",_firstResponder);
}
}
}),new objj_method(sel_getUid("selectKeyViewFollowingView:"),function(self,_cmd,_1a6){
with(self){
if(_keyViewLoopIsDirty){
objj_msgSend(self,"recalculateKeyViewLoop");
}
objj_msgSend(self,"makeFirstResponder:",objj_msgSend(_1a6,"nextValidKeyView"));
}
}),new objj_method(sel_getUid("selectKeyViewPrecedingView:"),function(self,_cmd,_1a9){
with(self){
if(_keyViewLoopIsDirty){
objj_msgSend(self,"recalculateKeyViewLoop");
}
objj_msgSend(self,"makeFirstResponder:",objj_msgSend(_1a9,"previousValidKeyView"));
}
}),new objj_method(sel_getUid("setDefaultButtonCell:"),function(self,_cmd,_1ac){
with(self){
objj_msgSend(self,"setDefaultButton:",_1ac);
}
}),new objj_method(sel_getUid("defaultButtonCell"),function(self,_cmd){
with(self){
return objj_msgSend(self,"defaultButton");
}
}),new objj_method(sel_getUid("setDefaultButton:"),function(self,_cmd,_1b1){
with(self){
objj_msgSend(_defaultButton,"setDefaultButton:",NO);
_defaultButton=_1b1;
objj_msgSend(_defaultButton,"setDefaultButton:",YES);
}
}),new objj_method(sel_getUid("defaultButton"),function(self,_cmd){
with(self){
return _defaultButton;
}
}),new objj_method(sel_getUid("enableKeyEquivalentForDefaultButton"),function(self,_cmd){
with(self){
_defaultButtonEnabled=YES;
}
}),new objj_method(sel_getUid("enableKeyEquivalentForDefaultButtonCell"),function(self,_cmd){
with(self){
objj_msgSend(self,"enableKeyEquivalentForDefaultButton");
}
}),new objj_method(sel_getUid("disableKeyEquivalentForDefaultButton"),function(self,_cmd){
with(self){
_defaultButtonEnabled=NO;
}
}),new objj_method(sel_getUid("disableKeyEquivalentForDefaultButtonCell"),function(self,_cmd){
with(self){
objj_msgSend(self,"disableKeyEquivalentForDefaultButton");
}
})]);
class_addMethods(_a,[new objj_method(sel_getUid("initialize"),function(self,_cmd){
with(self){
if(self!=objj_msgSend(CPWindow,"class")){
return;
}
var _1be=objj_msgSend(CPBundle,"bundleForClass:",objj_msgSend(CPWindow,"class"));
_8=objj_msgSend(objj_msgSend(CPImage,"alloc"),"initWithContentsOfFile:size:",objj_msgSend(_1be,"pathForResource:","CPProgressIndicator/CPProgressIndicatorSpinningStyleRegular.gif"),CGSizeMake(16,16));
}
}),new objj_method(sel_getUid("_windowViewClassForStyleMask:"),function(self,_cmd,_1c1){
with(self){
if(_1c1&CPHUDBackgroundWindowMask){
return _CPHUDWindowView;
}else{
if(_1c1===CPBorderlessWindowMask){
return _CPBorderlessWindowView;
}else{
if(_1c1&CPDocModalWindowMask){
return _CPDocModalWindowView;
}
}
}
return _CPStandardWindowView;
}
}),new objj_method(sel_getUid("_windowViewClassForFullPlatformWindowStyleMask:"),function(self,_cmd,_1c4){
with(self){
return _CPBorderlessBridgeWindowView;
}
}),new objj_method(sel_getUid("frameRectForContentRect:styleMask:"),function(self,_cmd,_1c7,_1c8){
with(self){
return objj_msgSend(objj_msgSend(objj_msgSend(self,"class"),"_windowViewClassForStyleMask:",_styleMask),"frameRectForContentRect:",_1c7);
}
})]);
var _190=function(a,b,_1cb){
var _1cc=objj_msgSend(a,"convertRect:toView:",objj_msgSend(a,"bounds"),nil),_1cd=objj_msgSend(b,"convertRect:toView:",objj_msgSend(b,"bounds"),nil);
if(CGRectGetMinY(_1cc)<CGRectGetMinY(_1cd)){
return -1;
}else{
if(CGRectGetMinY(_1cc)==CGRectGetMinY(_1cd)&&CGRectGetMinX(_1cc)<CGRectGetMinX(_1cd)){
return -1;
}else{
if(CGRectGetMinX(_1cc)==CGRectGetMinX(_1cd)&&CGRectGetMinX(_1cc)==CGRectGetMinX(_1cd)){
return 0;
}else{
return 1;
}
}
}
};
var _9=objj_getClass("CPWindow");
if(!_9){
objj_exception_throw(new objj_exception(OBJJClassNotFoundException,"*** Could not find definition for class \"CPWindow\""));
}
var _a=_9.isa;
class_addMethods(_9,[new objj_method(sel_getUid("_synchronizeMenuBarTitleWithWindowTitle"),function(self,_cmd){
with(self){
if(!objj_msgSend(_windowController,"document")||!objj_msgSend(self,"isMainWindow")){
return;
}
objj_msgSend(CPMenu,"setMenuBarTitle:",_title);
}
})]);
var _9=objj_getClass("CPWindow");
if(!_9){
objj_exception_throw(new objj_exception(OBJJClassNotFoundException,"*** Could not find definition for class \"CPWindow\""));
}
var _a=_9.isa;
class_addMethods(_9,[new objj_method(sel_getUid("resizeWithOldPlatformWindowSize:"),function(self,_cmd,_1d2){
with(self){
if(objj_msgSend(self,"isFullPlatformWindow")){
return objj_msgSend(self,"setFrame:",objj_msgSend(_platformWindow,"visibleFrame"));
}
if(_autoresizingMask==CPWindowNotSizable){
return;
}
var _1d3=objj_msgSend(_platformWindow,"contentBounds"),_1d4=CGRectMakeCopy(_frame),dX=(CGRectGetWidth(_1d3)-_1d2.width)/(((_autoresizingMask&CPWindowMinXMargin)?1:0)+(_autoresizingMask&CPWindowWidthSizable?1:0)+(_autoresizingMask&CPWindowMaxXMargin?1:0)),dY=(CGRectGetHeight(_1d3)-_1d2.height)/((_autoresizingMask&CPWindowMinYMargin?1:0)+(_autoresizingMask&CPWindowHeightSizable?1:0)+(_autoresizingMask&CPWindowMaxYMargin?1:0));
if(_autoresizingMask&CPWindowMinXMargin){
_1d4.origin.x+=dX;
}
if(_autoresizingMask&CPWindowWidthSizable){
_1d4.size.width+=dX;
}
if(_autoresizingMask&CPWindowMinYMargin){
_1d4.origin.y+=dY;
}
if(_autoresizingMask&CPWindowHeightSizable){
_1d4.size.height+=dY;
}
objj_msgSend(self,"setFrame:",_1d4);
}
}),new objj_method(sel_getUid("setAutoresizingMask:"),function(self,_cmd,_1d9){
with(self){
_autoresizingMask=_1d9;
}
}),new objj_method(sel_getUid("autoresizingMask"),function(self,_cmd){
with(self){
return _autoresizingMask;
}
}),new objj_method(sel_getUid("convertBaseToGlobal:"),function(self,_cmd,_1de){
with(self){
return objj_msgSend(CPPlatform,"isBrowser")?objj_msgSend(self,"convertBaseToPlatformWindow:",_1de):objj_msgSend(self,"convertBaseToScreen:",_1de);
}
}),new objj_method(sel_getUid("convertGlobalToBase:"),function(self,_cmd,_1e1){
with(self){
return objj_msgSend(CPPlatform,"isBrowser")?objj_msgSend(self,"convertPlatformWindowToBase:",_1e1):objj_msgSend(self,"convertScreenToBase:",_1e1);
}
}),new objj_method(sel_getUid("convertBaseToPlatformWindow:"),function(self,_cmd,_1e4){
with(self){
if(objj_msgSend(self,"_sharesChromeWithPlatformWindow")){
return _1e4;
}
var _1e5=objj_msgSend(self,"frame").origin;
return {x:_1e4.x+_1e5.x,y:_1e4.y+_1e5.y};
}
}),new objj_method(sel_getUid("convertPlatformWindowToBase:"),function(self,_cmd,_1e8){
with(self){
if(objj_msgSend(self,"_sharesChromeWithPlatformWindow")){
return _1e8;
}
var _1e9=objj_msgSend(self,"frame").origin;
return {x:_1e8.x-_1e9.x,y:_1e8.y-_1e9.y};
}
}),new objj_method(sel_getUid("convertScreenToBase:"),function(self,_cmd,_1ec){
with(self){
return objj_msgSend(self,"convertPlatformWindowToBase:",objj_msgSend(_platformWindow,"convertScreenToBase:",_1ec));
}
}),new objj_method(sel_getUid("convertBaseToScreen:"),function(self,_cmd,_1ef){
with(self){
return objj_msgSend(_platformWindow,"convertBaseToScreen:",objj_msgSend(self,"convertBaseToPlatformWindow:",_1ef));
}
}),new objj_method(sel_getUid("_setSharesChromeWithPlatformWindow:"),function(self,_cmd,_1f2){
with(self){
if(_1f2&&objj_msgSend(CPPlatform,"isBrowser")){
return;
}
_sharesChromeWithPlatformWindow=_1f2;
}
}),new objj_method(sel_getUid("_sharesChromeWithPlatformWindow"),function(self,_cmd){
with(self){
return _sharesChromeWithPlatformWindow;
}
}),new objj_method(sel_getUid("undoManager"),function(self,_cmd){
with(self){
if(_delegateRespondsToWindowWillReturnUndoManagerSelector){
return objj_msgSend(_delegate,"windowWillReturnUndoManager:",self);
}
if(!_undoManager){
_undoManager=objj_msgSend(objj_msgSend(CPUndoManager,"alloc"),"init");
}
return _undoManager;
}
}),new objj_method(sel_getUid("undo:"),function(self,_cmd,_1f9){
with(self){
objj_msgSend(objj_msgSend(self,"undoManager"),"undo");
}
}),new objj_method(sel_getUid("redo:"),function(self,_cmd,_1fc){
with(self){
objj_msgSend(objj_msgSend(self,"undoManager"),"redo");
}
}),new objj_method(sel_getUid("containsPoint:"),function(self,_cmd,_1ff){
with(self){
return CGRectContainsPoint(_frame,_1ff);
}
})]);
var _9=objj_getClass("CPWindow");
if(!_9){
objj_exception_throw(new objj_exception(OBJJClassNotFoundException,"*** Could not find definition for class \"CPWindow\""));
}
var _a=_9.isa;
class_addMethods(_9,[new objj_method(sel_getUid("setFullBridge:"),function(self,_cmd,_202){
with(self){
objj_msgSend(self,"setFullPlatformWindow:",_202);
}
}),new objj_method(sel_getUid("isFullBridge"),function(self,_cmd){
with(self){
return objj_msgSend(self,"isFullPlatformWindow");
}
}),new objj_method(sel_getUid("convertBaseToBridge:"),function(self,_cmd,_207){
with(self){
return objj_msgSend(self,"convertBaseToPlatformWindow:",_207);
}
}),new objj_method(sel_getUid("convertBridgeToBase:"),function(self,_cmd,_20a){
with(self){
return objj_msgSend(self,"convertPlatformWindowToBase:",_20a);
}
})]);
var _20b=function(_20c,_20d,_20e){
return _20c+(_20d-_20c)*_20e;
};
var _9=objj_allocateClassPair(CPAnimation,"_CPWindowFrameAnimation"),_a=_9.isa;
class_addIvars(_9,[new objj_ivar("_window"),new objj_ivar("_startFrame"),new objj_ivar("_targetFrame")]);
objj_registerClassPair(_9);
objj_addClassForBundle(_9,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_9,[new objj_method(sel_getUid("initWithWindow:targetFrame:"),function(self,_cmd,_211,_212){
with(self){
self=objj_msgSendSuper({receiver:self,super_class:objj_getClass("CPAnimation")},"initWithDuration:animationCurve:",0.2,CPAnimationLinear);
if(self){
_window=_211;
_targetFrame=CGRectMakeCopy(_212);
_startFrame=CGRectMakeCopy(objj_msgSend(_window,"frame"));
}
return self;
}
}),new objj_method(sel_getUid("startAnimation"),function(self,_cmd){
with(self){
objj_msgSendSuper({receiver:self,super_class:objj_getClass("CPAnimation")},"startAnimation");
_window._isAnimating=YES;
}
}),new objj_method(sel_getUid("setCurrentProgress:"),function(self,_cmd,_217){
with(self){
objj_msgSendSuper({receiver:self,super_class:objj_getClass("CPAnimation")},"setCurrentProgress:",_217);
var _218=objj_msgSend(self,"currentValue");
if(_218==1){
_window._isAnimating=NO;
}
objj_msgSend(_window,"setFrameOrigin:",CGPointMake(_20b(CGRectGetMinX(_startFrame),CGRectGetMinX(_targetFrame),_218),_20b(CGRectGetMinY(_startFrame),CGRectGetMinY(_targetFrame),_218)));
objj_msgSend(_window,"setFrameSize:",CGSizeMake(_20b(CGRectGetWidth(_startFrame),CGRectGetWidth(_targetFrame),_218),_20b(CGRectGetHeight(_startFrame),CGRectGetHeight(_targetFrame),_218)));
}
})]);
_CPWindowFullPlatformWindowSessionMake=function(_219,_21a,_21b,_21c){
return {windowView:_219,contentRect:_21a,hasShadow:_21b,level:_21c};
};
i;15;_CPWindowView.ji;23;_CPStandardWindowView.ji;23;_CPDocModalWindowView.ji;18;_CPHUDWindowView.ji;25;_CPBorderlessWindowView.ji;31;_CPBorderlessBridgeWindowView.ji;14;CPDragServer.ji;8;CPView.j