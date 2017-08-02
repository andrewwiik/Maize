#import "MZEExpandedModulePresentationTransition.h"
#import "MZEContentModuleContainerViewController.h"


@implementation MZEExpandedModulePresentationTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 10;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {


	MZEContentModuleContainerViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];


	CGRect relativeFrame = [[transitionContext containerView] convertRect:toViewController.view.frame fromView:((UIViewController *)toViewController.delegate).view];
	toViewController.contentContainerView.frame = relativeFrame;

	if (toViewController.backgroundViewController) {
		// toViewController.backgroundViewController.view.frame = [toViewController _backgroundFrameForExpandedState];
		[toViewController.backgroundViewController.view setAutoresizingMask:18];
		[toViewController.backgroundView addSubview:toViewController.backgroundViewController.view];
		// [toViewController.view sendSubviewToBack:toViewController.backgroundViewController.view];
		// [toViewController.view sendSubviewToBack:toViewController.backgroundView];
	}
	toViewController.backgroundView.frame = [toViewController _backgroundFrameForExpandedState];
	[toViewController.view bringSubviewToFront:toViewController.contentContainerView];
	toViewController.view.frame = [transitionContext containerView].bounds;
	[[transitionContext containerView] addSubview:toViewController.view];

	toViewController.expanded = YES;

	//[toViewController.contentViewController viewWillTransitionToSize:[toViewController _contentFrameForExpandedState] withTransitionCoordinator:]
	[UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
		toViewController.backgroundView.alpha = 1.0;
		[toViewController.contentContainerView transitionToExpandedMode:YES];
		toViewController.contentContainerView.frame = [toViewController _contentFrameForExpandedState];

		if ([toViewController.contentViewController respondsToSelector:@selector(willTransitionToExpandedContentMode:)]) {
			[toViewController.contentViewController willTransitionToExpandedContentMode:YES];
		}
	} completion:^(BOOL finished) {
		[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
	}];
}
@end