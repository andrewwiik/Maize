#import "SBUIForceTouchGestureRecognizer.h"

@interface SBUIIconForceTouchController : NSObject
+ (void)_addIconForceTouchController:(SBUIIconForceTouchController *)forceTouchController;
- (id)init;
- (void)setDataSource:(id)dataSource;
- (void)setDelegate:(id)delegate;
- (void)startHandlingGestureRecognizer:(id)arg1;
+ (void)_dismissAnimated:(BOOL)arg1 withCompletionHandler:(/*^block*/id)arg2;
+ (BOOL)_isPeekingOrShowing;
@property (nonatomic,readonly) NSInteger state;
- (void)_setupWithGestureRecognizer:(SBUIForceTouchGestureRecognizer *)gestureRecognizer;
- (void)_peekAnimated:(BOOL)animated withRelativeTouchForce:(CGFloat)touchForce allowSmoothing:(BOOL)allowSmoothing;
- (void)_presentAnimated:(BOOL)animated withCompletionHandler:(/*^block*/id)arg2;
-(void)_dismissAnimated:(BOOL)animated withCompletionHandler:(/*^block*/id)arg2;
@end