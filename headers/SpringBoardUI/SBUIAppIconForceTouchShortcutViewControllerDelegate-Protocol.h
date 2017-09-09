@protocol SBUIAppIconForceTouchShortcutViewControllerDelegate <NSObject>
@required
-(BOOL)appIconForceTouchShortcutViewControllerShouldHandleGestureRecognizers:(id)arg1;
-(void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(id)arg2;

@end