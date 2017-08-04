#import "MZEExpandedModuleDismissTransition.h"
#import "MZEContentModuleContainerViewController.h"


@implementation MZEExpandedModuleDismissTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {


	MZEContentModuleContainerViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];


	CGRect relativeFrame = [[transitionContext containerView] convertRect:[toViewController _contentFrameForRestState] fromView:((UIViewController *)toViewController.delegate).view];
	// toViewController.contentContainerView.frame = relativeFrame;

	// if (toViewController.backgroundViewController) {
	// 	// toViewController.backgroundViewController.view.frame = [toViewController _backgroundFrameForExpandedState];
	// 	[toViewController.backgroundViewController.view setAutoresizingMask:18];
	// 	[toViewController.backgroundView addSubview:toViewController.backgroundViewController.view];
	// 	// [toViewController.view sendSubviewToBack:toViewController.backgroundViewController.view];
	// 	// [toViewController.view sendSubviewToBack:toViewController.backgroundView];
	// }
	// toViewController.backgroundView.frame = [toViewController _backgroundFrameForExpandedState];
	// [toViewController.view bringSubviewToFront:toViewController.contentContainerView];
	// toViewController.view.frame = [transitionContext containerView].bounds;
	// [[transitionContext containerView] addSubview:toViewController.view];


	toViewController.expanded = NO;

	//[toViewController.contentViewController viewWillTransitionToSize:[toViewController _contentFrameForExpandedState] withTransitionCoordinator:]
	[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		toViewController.backgroundView.alpha = 0.0;
		[toViewController.contentContainerView transitionToExpandedMode:NO];
		toViewController.contentContainerView.frame = relativeFrame;

		if ([toViewController.contentViewController respondsToSelector:@selector(willTransitionToExpandedContentMode:)]) {
			[toViewController.contentViewController willTransitionToExpandedContentMode:NO];
		}
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
	}];
}
@end