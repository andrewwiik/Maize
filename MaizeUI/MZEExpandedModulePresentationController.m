#import "MZEExpandedModulePresentationController.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModuleCollectionViewController.h"
#import "MZEModularControlCenterViewController.h"

@implementation MZEExpandedModulePresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
	self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
	
	if (self) {

	}
	return self;
}

- (void)presentationTransitionWillBegin {

	if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
		controller.expanded = YES;
		id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
		[controller viewWillTransitionToSize:[controller _backgroundFrameForExpandedState].size withTransitionCoordinator:coordinator];
		[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
			[[MZEModularControlCenterViewController sharedCollectionViewController] contentModuleContainerViewController:controller willOpenExpandedModule:controller.contentModule];
		} completion:nil];
	}
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
	if (completed) {
		if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
			MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
			[[MZEModularControlCenterViewController sharedCollectionViewController] contentModuleContainerViewController:controller didOpenExpandedModule:controller.contentModule];
		}
	}
}

- (void)dismissalTransitionWillBegin {
    if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
		id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
		[controller viewWillTransitionToSize:[controller _backgroundFrameForRestState].size withTransitionCoordinator:coordinator];
		[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
			[[MZEModularControlCenterViewController sharedCollectionViewController] contentModuleContainerViewController:controller willCloseExpandedModule:controller.contentModule];
		} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
			[[MZEModularControlCenterViewController sharedCollectionViewController] contentModuleContainerViewController:controller didCloseExpandedModule:controller.contentModule];
			[[MZEModularControlCenterViewController sharedCollectionViewController].view addSubview:self.presentedViewController.view];
			[[MZEModularControlCenterViewController sharedCollectionViewController] addChildViewController:self.presentedViewController];
			[controller didMoveToParentViewController:[MZEModularControlCenterViewController sharedCollectionViewController]];
		}];
	}
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if(completed){
  //   	[self.presentedView removeFromSuperview];
    	if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
			MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
			[[MZEModularControlCenterViewController sharedCollectionViewController] contentModuleContainerViewController:controller didCloseExpandedModule:controller.contentModule];
		}
		// 	if (controller.delegate) {
		// 		[controller.delegate contentModuleContainerViewController:controller didCloseExpandedModule:controller.contentModule];
		// 		[((MZEModuleCollectionViewController *)controller.delegate).view addSubview:self.presentedViewController.view];
		// 	}
		// }
  //       HBLogInfo(@"DID END TRANSITION CLOSE: %@", self.presentedViewController);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	// if ([self.presentedViewController respondsToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
	// 	[self.presentedViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	// }





}

	


@end