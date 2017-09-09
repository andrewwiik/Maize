@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
@property (nonatomic,readonly) NSString * applicationBundleIdentifier; 
@property (nonatomic,readonly) NSURL * applicationBundleURL; 
@property (nonatomic,readonly) NSString * applicationShortcutWidgetBundleIdentifier; 
@property (nonatomic,readonly) NSArray * applicationShortcutItems; 
-(id)initWithDataSource:(id)arg1 controller:(id)arg2 gestureRecognizer:(id)arg3;
@end