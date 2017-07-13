#import "MZEMaterialView.h"
#import "MZECAPackageView.h"
@interface MZEModuleContainerViewController : UIViewController <UIPreviewInteractionDelegate> {
	CGRect _modulePosition;
	CGRect _compactModuleSize;
	NSString *_state;
	UITapGestureRecognizer *_tapRecognizer;
	MZECAPackageView *_packageView;
	NSString *_onState;
	NSString *_offState;
	NSString *_moduleName;
}
@property (nonatomic, retain) MZEMaterialView *darkBackground;
@property (nonatomic, retain) MZEMaterialView *lightBackground;
@property (nonatomic, retain) UIPreviewInteraction   *previewInteraction;
@property (nonatomic, retain) UIViewPropertyAnimator *animator;
@property (nonatomic, assign) CGRect modulePosition;
@property (nonatomic, assign) id<UIPreviewInteractionDelegate> collectionViewController;
@property (nonatomic, assign) BOOL isExpanded;
- (id)initWithIdentifier:(NSString *)identifier;
- (CGRect)expandedModuleBackgroundRect;
- (CGFloat)expandedModuleBackgroundCornerRadius;
- (CGFloat)compactCornerRadius;
- (CGFloat)expandedCornerRadius;
- (BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)arg1;
- (void)previewInteraction:(UIPreviewInteraction *)arg1 didUpdatePreviewTransition:(CGFloat)arg2 ended:(BOOL)arg3;
- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended;
- (void)previewInteractionDidCancel:(UIPreviewInteraction *)arg1;
- (CGRect)compactModuleSize;
- (void)toggleState;
@end