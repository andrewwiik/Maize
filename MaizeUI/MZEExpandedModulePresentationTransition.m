#import "MZEExpandedModulePresentationTransition.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModularControlCenterViewController.h"


@implementation MZEExpandedModulePresentationTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {


	MZEContentModuleContainerViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];


	CGRect relativeFrame = [[transitionContext containerView] convertRect:toViewController.view.frame fromView:[MZEModularControlCenterViewController sharedCollectionViewController].view];
	toViewController.contentContainerView.frame = relativeFrame;
	toViewController.backgroundView.frame = [toViewController _backgroundFrameForExpandedState];
	[toViewController.view bringSubviewToFront:toViewController.contentContainerView];
	toViewController.view.frame = [transitionContext containerView].bounds;
	[[transitionContext containerView] addSubview:toViewController.view];

	toViewController.expanded = YES;

	//[toViewController.contentViewController viewWillTransitionToSize:[toViewController _contentFrameForExpandedState] withTransitionCoordinator:]
	[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
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