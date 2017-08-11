#import "MZEConnectivityWiFiNetworksViewController.h"
#import <MaizeUI/MZELayoutOptions.h>
#import <UIKit/UIView+Private.h>

@implementation MZEConnectivityWiFiNetworksViewController
- (id)init {
	self = [super init];
	if (self) {
		if ([self respondsToSelector:@selector(setTransitioningDelegate:)]) {
        	self.modalPresentationStyle = UIModalPresentationCustom;
			self.transitioningDelegate = self;
		}

		if (!_networksListController) {
			_networksListController = [NSClassFromString(@"MZEConnectivityWiFiNetworksListController") sharedInstance];
			_navigationController = [[UINavigationController alloc] initWithRootViewController:_networksListController];
			_navigationController.navigationBarHidden = YES;
		}
	}
	return self;
}

- (void)viewWillLayoutSubviews {

	if (!_tapBackgroundView) {
		_tapBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
		[self.view addSubview:_tapBackgroundView];
		_tapBackgroundView.autoresizingMask = 18;
		UITapGestureRecognizer  *_tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTapGestureRecognizer:)];
		[_tapBackgroundView addGestureRecognizer:_tapRecognizer];
	}

	if (!_containerView) {
		_containerView = [[UIView alloc] initWithFrame:[self _contentFrame]];
		[self.view addSubview:_containerView];
		_containerView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | 
										   UIViewAutoresizingFlexibleRightMargin | 
 										   UIViewAutoresizingFlexibleTopMargin | 
 										   UIViewAutoresizingFlexibleBottomMargin);

		_containerView._continuousCornerRadius = [MZELayoutOptions expandedModuleCornerRadius];
		_containerView.clipsToBounds = YES;

		_backgroundView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
		_backgroundView.frame = _containerView.bounds;
		[_containerView addSubview:_backgroundView];
		_backgroundView.autoresizingMask = 18;

		_headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,_containerView.bounds.size.width, [MZELayoutOptions defaultMenuItemHeight])];
		[_containerView addSubview:_headerView];
		_headerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
										UIViewAutoresizingFlexibleTopMargin | 
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleLeftMargin);


		CGFloat separatorHeight = 1.0f/[UIScreen mainScreen].scale;
		_topDividerView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
		_topDividerView.frame = CGRectMake(0,_headerView.bounds.size.height - separatorHeight,CGRectGetWidth(_containerView.bounds), separatorHeight);
		[_headerView addSubview:_topDividerView];
		_topDividerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
										UIViewAutoresizingFlexibleBottomMargin | 
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleLeftMargin);

		CGRect navBounds = _containerView.bounds;
		navBounds.origin.y = _headerView.bounds.size.height;
		navBounds.size.height -= _headerView.bounds.size.height * 2;
		_navigationController.view.frame = navBounds;

		[_containerView addSubview:_navigationController.view];

		_networksListController.view.bounds = _navigationController.view.bounds;
		_networksListController.view.autoresizingMask = 18;
		_navigationController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
													   UIViewAutoresizingFlexibleRightMargin |
													   UIViewAutoresizingFlexibleLeftMargin);
		[self addChildViewController:_navigationController];
		[_navigationController didMoveToParentViewController:self];

		_footerView = [[UIView alloc] initWithFrame:CGRectMake(0,navBounds.size.height + _headerView.bounds.size.height,_containerView.bounds.size.width, [MZELayoutOptions defaultMenuItemHeight])];
		[_containerView addSubview:_footerView];
		_footerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
										UIViewAutoresizingFlexibleBottomMargin | 
										UIViewAutoresizingFlexibleRightMargin |
										UIViewAutoresizingFlexibleLeftMargin);

		_bottomDividerView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
		_bottomDividerView.frame = CGRectMake(0,0,CGRectGetWidth(_containerView.bounds), separatorHeight);
		[_footerView addSubview:_bottomDividerView];
		_bottomDividerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
											   UIViewAutoresizingFlexibleTopMargin | 
											   UIViewAutoresizingFlexibleRightMargin |
											   UIViewAutoresizingFlexibleLeftMargin);

	}

	if (_containerView) {
		_containerView.center = self.view.center;
	}
}

- (void)_handleTapGestureRecognizer:(id)gesture {
	[self dismissViewControllerAnimated:YES completion:^{
		[self.buttonController didDismissSecondaryViewController:self];
	}];
}

- (CGRect)_contentFrameForExpandedState {
	CGRect frame = CGRectZero;
	frame.size.width = [MZELayoutOptions defaultExpandedModuleWidth];
	frame.size.height = [MZELayoutOptions defaultExpandedSliderHeight];
	return frame;
}

- (CGRect)_contentFrame {
	CGRect frame = self.view.bounds;
	frame.size.width = [MZELayoutOptions defaultExpandedModuleWidth];
	frame.size.height = [MZELayoutOptions defaultExpandedSliderHeight] + ([MZELayoutOptions defaultMenuItemHeight] * 2);
	frame.origin.x = self.view.bounds.size.width/2 - frame.size.width/2;
	frame.origin.y = self.view.bounds.size.height/2 - frame.size.height/2;
	return frame;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
	return [[MZEExpandedModulePresentationTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
   return [[MZEExpandedModuleDismissTransition alloc] init];
}

// show the proxy method of the view
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
   return [[MZEExpandedModulePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}
@end