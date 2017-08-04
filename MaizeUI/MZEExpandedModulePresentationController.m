#import "MZEExpandedModulePresentationController.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModuleCollectionViewController.h"

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
		if (controller.delegate) {
			id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
	
			[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
				[controller.delegate contentModuleContainerViewController:controller willOpenExpandedModule:controller.contentModule];
			} completion:nil];
		}
	}
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
	if (completed) {
		if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
			MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
			if (controller.delegate) {
				[controller.delegate contentModuleContainerViewController:controller didOpenExpandedModule:controller.contentModule];
			}
		}
	}
}

- (void)dismissalTransitionWillBegin {
    if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
		if (controller.delegate) {
			id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
	
			[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
				[controller.delegate contentModuleContainerViewController:controller willCloseExpandedModule:controller.contentModule];
			} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
				[controller.delegate contentModuleContainerViewController:controller didCloseExpandedModule:controller.contentModule];
				[((MZEModuleCollectionViewController *)controller.delegate).view addSubview:self.presentedViewController.view];
				[(MZEModuleCollectionViewController *)controller.delegate addChildViewController:self.presentedViewController];
				[controller didMoveToParentViewController:(MZEModuleCollectionViewController *)controller.delegate];
			}];
		}
	}
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if(completed){
  //   	[self.presentedView removeFromSuperview];
  //   	if ([self.presentedViewController isKindOfClass:[MZEContentModuleContainerViewController class]]) {
		// 	MZEContentModuleContainerViewController *controller = (MZEContentModuleContainerViewController *)self.presentedViewController;
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
	if ([self.presentedViewController respondsToSelector:@selector(viewWillTransitionToSize:withTransitionCoordinator:)]) {
		[self.presentedViewController viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
	}





}

	


@end