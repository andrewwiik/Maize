#import "MZEModuleCollectionViewControllerDelegate-Protocol.h"
#import <UIKit/UIWindow+Orientation.h>
#import "MZEModuleCollectionViewController.h"
#import "MZEAnimatedBlurView.h"
#import "_MZEBackdropView.h"
#import "MZEHeaderPocketView.h"

@interface MZEModularControlCenterViewController : UIViewController <MZEModuleCollectionViewControllerDelegate> {
	CGRect _initFrame;
	CGFloat _openCollectionViewYOrigin;
	CGFloat _closedCollectionViewYOrigin;
	MZEAnimatedBlurView *_animatedBackgroundView;
	UIView *_luminanceBackgroundView;
	_MZEBackdropView *_luminanceBackdropView;
	MZEModuleCollectionViewController *_collectionViewController;
	UIViewPropertyAnimator *_animator;
}
@property (nonatomic, retain, readwrite) MZEAnimatedBlurView *animatedBackgroundView;
@property (nonatomic, retain, readwrite) UIView *luminanceBackgroundView;
@property (nonatomic, retain, readwrite) MZEHeaderPocketView *headerPocket;
@property (nonatomic, retain, readwrite) _MZEBackdropView *luminanceBackdropView;
@property (nonatomic, retain, readwrite) MZEModuleCollectionViewController *collectionViewController;
@property (nonatomic, retain, readwrite) UIViewPropertyAnimator *animator;
- (id)initWithFrame:(CGRect)frame;
- (void)revealWithProgress:(CGFloat)progress;
- (BOOL)isLandscape;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willRemoveModuleContainerViewController:(MZEContentModuleContainerViewController *)moduleContainerViewController;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didAddModuleContainerViewController:(MZEContentModuleContainerViewController *)moduleContainerViewController;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didCloseExpandedModule:(id <MZEContentModule>)module;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willCloseExpandedModule:(id <MZEContentModule>)module;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didOpenExpandedModule:(id <MZEContentModule>)module;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController willOpenExpandedModule:(id <MZEContentModule>)module;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didFinishInteractionWithModule:(id <MZEContentModule>)module;
- (void)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController didBeginInteractionWithModule:(id <MZEContentModule>)module;
- (NSInteger)interfaceOrientationForModuleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController;
- (BOOL)moduleCollectionViewController:(MZEModuleCollectionViewController *)collectionViewController shouldForwardAppearanceCall:(BOOL)shouldForward animated:(BOOL)animated;
- (void)willResignActive;
- (void)willBecomeActive;
@end
