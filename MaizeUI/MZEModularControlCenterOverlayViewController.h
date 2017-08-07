#import "MZEModularControlCenterViewController.h"
#import "MZEScrollView.h"
#import "MZEScrollViewDelegate-Protocol.h"
#import "MZEPresentationState.h"
#import "MZEBackgroundView.h"
#import "MZEHeaderPocketView"

@interface MZEModularControlCenterOverlayViewController : MZEModularControlCenterViewController <MZEScrollViewDelegate> {
	CGRect _cachedTargetPresentationFrame;
	CGRect _cachedSourcePresentationFrame;
	MZEPresentationState _presentationState;

	MZEScrollView *_scrollView;
	MZEHeaderPocketView *_headerPocketView;

	MZEBackgroundView *_backgroundView;

	UIPanGestureRecognizer *_headerPocketViewDismissalPanGesture;
	UITapGestureRecognizer *_headerPocketViewDismissalTapGesture;
	UIPanGestureRecognizer *_collectionViewDismissalPanGesture;
	UITapGestureRecognizer *_collectionViewDismissalTapGesture;
	UIPanGestureRecognizer *_collectionViewScrollPanGesture;
	CGFloat _dismissalGestureYOffset;
}

@property (nonatomic, retain, readwrite) MZEBackgroundView *backgroundView;
@property (nonatomic, readwrite) MZEPresentationState presentationState;


- (CGRect)_targetPresentationFrame;
- (CGRect)_sourcePresentationFrame;
- (void)_beginPresentationAnimated:(BOOL)animated;
- (void)presentAnimated:(BOOL)animated withCompletionHandler:(id)completionHandler;
- (void)dismissAnimated:(BOOL)animated withCompletionHandler:(id)completionHandler;

- (void)updatePresentationForRevealPercentage:(CGFloat)percentage;
- (void)revealWithProgress:(CGFloat)progress;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator;
- (void)viewWillLayoutSubviews;
- (void)viewDidLoad;

#pragma mark Gestures and Scrolling

- (void)_makePresentationFramesDirty;
- (BOOL)_allowScrollWithPanGesture:(UIPanGestureRecognizer *)panRecognizer;
- (CGFloat)_presentationGestureActivationMinimumYOffset;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (BOOL)scrollView:(MZEScrollView *)scrollView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)_allowScrollWithPanGesture:(UIPanGestureRecognizer *)gestureRecognizer;

#pragma mark Dismissal Gesture

- (void)_handleControlCenterDismissalPanGesture:(UIPanGestureRecognizer *)gesture;

- (void)_beginDismissal;

- (void)_beginDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture;
- (void)_updateDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture;
- (void)_endDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture;
- (void)_cancelDismissalWithPanGesture:(UIPanGestureRecognizer *)gesture;


#pragma mark Module Collection View 
- (UIView *)_moduleCollectionViewContainerView;
- (void)_setCollectionViewOriginYUpdatingRevealPercentage:(CGFloat)percentage;
- (void)_setCollectionViewOriginY:(CGFloat)yOrigin revealPercentage:(CGFloat)percentage;
- (void)_setCollectionViewOriginAccountingForContentInset:(CGPoint)origin;
- (void)_animateSetCollectionViewOriginYUpdatingRevealPercentage:(CGFloat)percentage;

#pragma mark Header Pocket View

- (void)_updateHotPocketAnimated:(BOOL)animated;
- (void)_setPocketViewOriginFromCollectionOriginY:(CGFloat)yOrigin revealPercentage:(CGFloat)revealPercentage;


@end