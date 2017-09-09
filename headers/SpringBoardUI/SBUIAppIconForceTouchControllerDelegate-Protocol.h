@protocol SBUIAppIconForceTouchControllerDelegate <NSObject>
@optional
-(BOOL)appIconForceTouchController:(id)arg1 shouldHandleGestureRecognizer:(id)arg2;
-(BOOL)appIconForceTouchController:(id)arg1 shouldUseSecureWindowForGestureRecognizer:(id)arg2;
-(void)appIconForceTouchController:(id)arg1 willPresentForGestureRecognizer:(id)arg2;
-(void)appIconForceTouchController:(id)arg1 didPresentForGestureRecognizer:(id)arg2;
-(void)appIconForceTouchController:(id)arg1 willDismissForGestureRecognizer:(id)arg2;
-(void)appIconForceTouchController:(id)arg1 didDismissForGestureRecognizer:(id)arg2;
-(BOOL)appIconForceTouchController:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forGestureRecognizer:(id)arg4;

@end

