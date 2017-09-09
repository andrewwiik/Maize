@interface SBUIAppIconForceTouchShortcutViewController : UIViewController
@property (nonatomic,readonly) NSArray * applicationShortcutItems;                                                 //@synthesize applicationShortcutItems=_applicationShortcutItems - In the implementation block
@property (assign,nonatomic) BOOL reversesApplicationShortcutItems;  
-(id)initWithDataProvider:(id)arg1 applicationShortcutItems:(id)arg2;
-(id)initWithCoder:(id)arg1;
-(id)initWithNibName:(id)arg1 bundle:(id)arg2;
-(id)_actionFromApplicationShortcutItem:(id)shortcutItem;
@end
