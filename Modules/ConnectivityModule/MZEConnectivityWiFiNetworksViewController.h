#import "MZEConnectivityWiFiNetworksListController.h"
#import "MZEConnectivityButtonViewController.h"
#import <MaizeUI/MZEMaterialView.h>
#import <MaizeUI/MZEExpandedModuleTransition-Protocol.h>
#import <MaizeUI/MZEExpandedModulePresentationTransition.h>
#import <MaizeUI/MZEExpandedModulePresentationController.h>
#import <MaizeUI/MZEExpandedModuleDismissTransition.h>

@interface MZEConnectivityWiFiNetworksViewController : UIViewController <MZEExpandedModuleTransition, UIViewControllerTransitioningDelegate> {
	UIView *_headerView;
	UIView *_footerView;
	MZEConnectivityWiFiNetworksListController *_networksListController;
	MZEMaterialView *_topDividerView;
	MZEMaterialView *_bottomDividerView;
	MZEMaterialView *_backgroundView;
	UIView *_containerView;
	UIView *_tapBackgroundView;
	UINavigationController *_navigationController;
}
- (id)init;
- (CGRect)_contentFrameForExpandedState;
@property (nonatomic, retain) MZEConnectivityButtonViewController *buttonController;
@property (nonatomic, retain, readwrite) UIView *headerView;
@property (nonatomic, retain, readwrite) UIView *footerView;
@property (nonatomic, retain, readwrite) MZEConnectivityWiFiNetworksListController *networksListController;
@property (nonatomic, retain, readwrite) MZEMaterialView *topDividerView;
@property (nonatomic, retain, readwrite) MZEMaterialView *bottomDividerView;
@property (nonatomic, retain, readwrite) MZEMaterialView *backgroundView;
@property (nonatomic, retain, readwrite) UIView *containerView;
@property (nonatomic, retain, readwrite) UIView *tapBackgroundView;
@property (nonatomic, retain, readwrite) UINavigationController *navigationController;


- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source;

@end