#import "MZEConnectivityAirDropPopupViewController.h"
#import <UIKit/UIColor+Private.h>
#import <UIKit/UIImage+Private.h>
#import <UIKit/UIView+Private.h>

@implementation MZEConnectivityAirDropPopupViewController

- (id)init {
	self = [super init];
	if (self) {
		_bundle = [NSBundle bundleForClass:[self class]];
		if ([self respondsToSelector:@selector(setTransitioningDelegate:)]) {
        	self.modalPresentationStyle = UIModalPresentationCustom;
			self.transitioningDelegate = self;
		}

		// if (!_networksListController) {
		// 	_networksListController = [NSClassFromString(@"MZEConnectivityWiFiNetworksListController") sharedInstance];
		// 	_navigationController = [[UINavigationController alloc] initWithRootViewController:_networksListController];
		// 	_navigationController.navigationBarHidden = YES;
		// }
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

		// _backgroundView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
		// _backgroundView.frame = _containerView.bounds;

		if (_contentViewController) {
			_contentViewController.view.frame = [self _contentFrameForExpandedState];
			[_containerView addSubview:_contentViewController.view];
			_contentViewController.view.autoresizingMask = 18;
		}
		// [_containerView addSubview:_backgroundView];
		// _backgroundView.autoresizingMask = 18;


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
	frame.size.width = [_contentViewController preferredExpandedContentWidth];
	frame.size.height = [_contentViewController preferredExpandedContentHeight];
	return frame;
}

- (CGRect)_contentFrame {
	CGRect frame = self.view.bounds;
	frame.size.width = [_contentViewController preferredExpandedContentWidth];
	frame.size.height = [_contentViewController preferredExpandedContentHeight];
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

- (id)initWithDiscoveryController:(SFAirDropDiscoveryController *)discoveryController {
	self = [self init];
	if (self) {
		_discoveryController = discoveryController;
		_contentViewController = [[MZEConnectivityAirDropPopupContentViewController alloc] initWithRootController:self];
		_contentViewController.title = [_bundle localizedStringForKey:@"CONTROL_CENTER_STATUS_AIRDROP_NAME" value:@"Airdrop" table:nil];
		

		[_contentViewController addActionWithTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_EVERYONE_ONE_LINE" value:@"" table:nil] glyph:nil handler:(MZEMenuItemBlock)^{
			[discoveryController setDiscoverableMode:2];
			return YES;
		}];

		[_contentViewController addActionWithTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_CONTACTS_ONE_LINE" value:@"" table:nil] glyph:nil handler:(MZEMenuItemBlock)^{
			[discoveryController setDiscoverableMode:1];
			return YES;
		}];

		[_contentViewController addActionWithTitle:[_bundle localizedStringForKey:@"CONTROL_CENTER_AIRDROP_RECEIVING_OFF_ONE_LINE" value:@"" table:nil] glyph:nil handler:(MZEMenuItemBlock)^{
			[discoveryController setDiscoverableMode:0];
			return YES;
		}];

		[_contentViewController willTransitionToExpandedContentMode:YES];

		CGSize size = [self _contentFrame].size;
		[_contentViewController _layoutSeparatorForSize:size];
		[_contentViewController _layoutMenuItemsForSize:size];
		[_contentViewController _layoutTitleLabelForSize:size];
		[_contentViewController _layoutGlyphViewForSize:size];
	}
	return self;
}

// - (void)viewDidLoad {
// 	[super viewDidLoad];
// 	[self setGlyphImage:[UIImage imageNamed:@"AirDropGlyph" inBundle:[NSBundle bundleForClass:[self class]]]];

// 	// [_viewController addActionWithTitle: glyph:shortcutItem.image handler:(MZEMenuItemBlock)shortcutItem.block];
// }
@end