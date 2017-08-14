#import "MZEExpandedModuleDismissTransition.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModularControlCenterViewController.h"
#import <SpringBoard/SBFolderCloseSettings.h>
#import <BaseBoardUI/BSUIAnimationFactory.h>


@implementation MZEExpandedModuleDismissTransition
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {

	if ([[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey] isKindOfClass:NSClassFromString(@"MZEContentModuleContainerViewController")]) {

		MZEContentModuleContainerViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	    //UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];


		CGRect relativeFrame = [[transitionContext containerView] convertRect:[[MZEModularControlCenterViewController sharedCollectionViewController] compactModeFrameForContentModuleContainerViewController:toViewController] fromView:[MZEModularControlCenterViewController sharedCollectionViewController].view];
		// toViewController.contentContainerView.frame = relativeFrame;

		// if (toViewController.backgroundViewController) {
		// 	// toViewController.backgroundViewController.view.frame = [toViewController _backgroundFrameForExpandedState];
		// 	[toViewController.backgroundViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
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
		SBFolderCloseSettings *settings = [NSClassFromString(@"SBFolderCloseSettings") new];
		[settings setDefaultValues];
		BSUIAnimationFactory *factory = [NSClassFromString(@"BSUIAnimationFactory") factoryWithSettings:[[settings centralAnimationSettings] BSAnimationSettings]];
		//[toViewController.contentViewController viewWillTransitionToSize:[toViewController _contentFrameForExpandedState] withTransitionCoordinator:]
		

		[NSClassFromString(@"BSUIAnimationFactory") animateWithFactory:factory actions:^{
			toViewController.backgroundView.alpha = 0.0;
			[toViewController.contentContainerView transitionToExpandedMode:NO];
			toViewController.contentContainerView.frame = relativeFrame;

			if ([toViewController.contentViewController respondsToSelector:@selector(willTransitionToExpandedContentMode:)]) {
				[toViewController.contentViewController willTransitionToExpandedContentMode:NO];
			}
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	} else {
		UIViewController<MZEExpandedModuleTransition> *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
		UIViewController<MZEExpandedModuleTransition> *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

		// CGRect containerRect = [transitionContext containerView].bounds;
		// CGPoint center = UIRectGetCenter(containerRect);
		// CGRect toFrame = [toViewController _contentFrameForExpandedState];

		// toFrame.origin.x = center.x - (toFrame.size.width*0.5);
		// toFrame.origin.y = center.y - (toFrame.size.height*0.5);

		// toViewController.view.frame = toFrame;
		// toViewController.view.transform = CGAffineTransformMakeScale(0.8,0.8);
		// toViewController.view.alpha = 0.0;

		//[[transitionContext containerView] addSubview:toViewController.view];

		[UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction animations:^{
			toViewController.view.alpha = 1.0;
			toViewController.view.transform = CGAffineTransformIdentity;
			fromViewController.view.alpha = 0;
			fromViewController.view.transform = CGAffineTransformMakeScale(0.8,0.8);
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
}
@end