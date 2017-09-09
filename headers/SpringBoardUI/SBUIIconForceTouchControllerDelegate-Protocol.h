@protocol SBUIIconForceTouchControllerDelegate <NSObject>
@optional
-(BOOL)iconForceTouchController:(id)arg1 shouldHandleGestureRecognizer:(id)arg2;
-(BOOL)iconForceTouchController:(id)arg1 shouldUseSecureWindowForGestureRecognizer:(id)arg2;
-(void)iconForceTouchController:(id)arg1 willPresentForGestureRecognizer:(id)arg2;
-(void)iconForceTouchController:(id)arg1 didPresentForGestureRecognizer:(id)arg2;
-(void)iconForceTouchController:(id)arg1 willDismissForGestureRecognizer:(id)arg2;
-(void)iconForceTouchController:(id)arg1 didDismissForGestureRecognizer:(id)arg2;

@end