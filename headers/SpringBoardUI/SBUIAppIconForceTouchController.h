#import <SpringBoardUI/SBUIIconForceTouchController.h>
#import <SpringBoardUI/SBUIAppIconForceTouchControllerDataSource-Protocol.h>
#import <SpringBoardUI/SBUIAppIconForceTouchControllerDelegate-Protocol.h>
#import <SpringBoardUI/SBUIIconForceTouchControllerDelegate-Protocol.h>
#import <SpringBoardUI/SBUIIconForceTouchControllerDataSource-Protocol.h>
#import <SpringBoardUI/SBUIAppIconForceTouchShortcutViewControllerDelegate-Protocol.h>

@interface SBUIAppIconForceTouchController : NSObject <SBUIAppIconForceTouchShortcutViewControllerDelegate, SBUIIconForceTouchControllerDataSource, SBUIIconForceTouchControllerDelegate> {

	SBUIIconForceTouchController* _iconForceTouchController;
	UIViewController* _primaryViewController;
	UIViewController* _secondaryViewController;
	id<SBUIAppIconForceTouchControllerDataSource> _dataSource;
	id<SBUIAppIconForceTouchControllerDelegate> _delegate;

}

@property (nonatomic,readonly) NSInteger state; 
@property (assign,nonatomic) id<SBUIAppIconForceTouchControllerDataSource> dataSource;              //@synthesize dataSource=_dataSource - In the implementation block
@property (assign,nonatomic) id<SBUIAppIconForceTouchControllerDelegate> delegate;                  //@synthesize delegate=_delegate - In the implementation block
+(id)filteredApplicationShortcutItemsWithStaticApplicationShortcutItems:(NSArray *)staticShortcutItems dynamicApplicationShortcutItems:(NSArray *)dynamicShortcutItems;
-(id)init;
-(void)setDataSource:(id<SBUIAppIconForceTouchControllerDataSource>)dataSource;
-(void)setDelegate:(id<SBUIAppIconForceTouchControllerDelegate>)delegate;
-(id<SBUIAppIconForceTouchControllerDataSource>)dataSource;
-(id<SBUIAppIconForceTouchControllerDelegate>)delegate;
-(NSInteger)state;
-(void)_presentAnimated:(BOOL)animated withCompletionHandler:(/*^block*/id)completionHandler;
-(void)_dismissAnimated:(BOOL)animated withCompletionHandler:(/*^block*/id)completionHandler;
-(void)_setupWithGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer ;
-(void)_peekAnimated:(BOOL)animated withRelativeTouchForce:(CGFloat)touchForce allowSmoothing:(BOOL)allowSmoothing;
-(id)_widgetViewControllerForDataProvider:(id)dataProvider;
-(id)_shortcutViewControllerForDataProvider:(id)dataProvider;
-(BOOL)appIconForceTouchShortcutViewControllerShouldHandleGestureRecognizers:(NSArray<UIGestureRecognizer *> *)gestureRecognizer;
-(void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(id)shortcutItem;
-(void)stopHandlingGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(void)startHandlingGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(void)dismissAnimated:(BOOL)animated withCompletionHandler:(/*^block*/id)completionHandler;
-(BOOL)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController shouldHandleGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(BOOL)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController shouldUseSecureWindowForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(void)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController willPresentForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(void)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController didPresentForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(void)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController willDismissForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(void)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController didDismissForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(NSInteger)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController layoutStyleForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(UIView *)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController newIconViewCopyForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(CGRect)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController iconViewFrameForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(id)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController primaryViewControllerForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(id)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController secondaryViewControllerForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(UIEdgeInsets)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController iconImageInsetsForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(CGFloat)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController iconImageCornerRadiusForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(id)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController parallaxSettingsForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(UIView *)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController zoomDownViewForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
-(CGPoint)iconForceTouchController:(SBUIIconForceTouchController *)iconForceTouchController zoomDownCenterForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
@end