@protocol SBUIAppIconForceTouchControllerDataSource <NSObject>
@optional
-(id)appIconForceTouchController:(id)arg1 applicationBundleIdentifierForGestureRecognizer:(id)arg2;
-(id)appIconForceTouchController:(id)arg1 applicationBundleURLForGestureRecognizer:(id)arg2;
-(id)appIconForceTouchController:(id)arg1 applicationShortcutWidgetBundleIdentifierForGestureRecognizer:(id)arg2;
-(id)appIconForceTouchController:(id)arg1 applicationShortcutItemsForGestureRecognizer:(id)arg2;
-(UIEdgeInsets*)appIconForceTouchController:(id)arg1 iconImageInsetsForGestureRecognizer:(id)arg2;
-(double)appIconForceTouchController:(id)arg1 iconImageCornerRadiusForGestureRecognizer:(id)arg2;
-(id)appIconForceTouchController:(id)arg1 parallaxSettingsForGestureRecognizer:(id)arg2;
-(id)appIconForceTouchController:(id)arg1 zoomDownViewForGestureRecognizer:(id)arg2;
-(CGPoint*)appIconForceTouchController:(id)arg1 zoomDownCenterForGestureRecognizer:(id)arg2;

@required
-(id)appIconForceTouchController:(id)arg1 newIconViewCopyForGestureRecognizer:(id)arg2;
-(CGRect*)appIconForceTouchController:(id)arg1 iconViewFrameForGestureRecognizer:(id)arg2;

@end