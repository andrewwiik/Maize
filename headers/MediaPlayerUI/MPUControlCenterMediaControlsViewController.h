#import <MediaPlayerUI/MPUMediaRemoteViewController.h>
#import <ControlCenterUI/CCUIControlCenterPageContentViewControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingController.h>
#import <MediaPlayerUI/MPAVRoutingViewController.h>
#import <MediaPlayerUI/MPAVRoutingViewControllerDelegate-Protocol.h>
#import <MediaPlayerUI/MPUControlCenterMediaControlsViewDelegate-Protocol.h>
#import <ControlCenterUI/CCUIControlCenterPageContentProviding-Protocol.h>
#import <MediaPlayerUI/MPAVRoutingController.h>
#import <MediaPlayerUI/MPWeakTimer.h>
#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPUTransportControlsView.h>
#import <MediaPlayerUI/MPAVRouteHeaderView.h>
#import <MediaPlayerUI/MPUMediaRemoteControlsView.h>

@interface MPUControlCenterMediaControlsViewController : MPUMediaRemoteViewController <MPAVRoutingControllerDelegate, MPAVRoutingViewControllerDelegate, MPUControlCenterMediaControlsViewDelegate, CCUIControlCenterPageContentProviding> {

	id<CCUIControlCenterPageContentViewControllerDelegate> _delegate;
	MPAVRoutingViewController* _routingViewController;
	BOOL _routingViewVisible;
	BOOL _viewHasAppeared;
	BOOL _controlCenterPageIsVisible;
	MPWeakTimer* _controlCenterPageVisibilityUpdateTimer;

}

@property (nonatomic, retain) id<CCUIControlCenterPageContentViewControllerDelegate> delegate; 
@property (nonatomic,readonly) UIEdgeInsets contentInsets; 
@property (nonatomic,readonly) BOOL wantsVisible; 
+(Class)controlsViewClass;
+(Class)transportControlButtonClass;
-(void)setDelegate:(id<CCUIControlCenterPageContentViewControllerDelegate>)delegate;
// -(void)dealloc;
-(id<CCUIControlCenterPageContentViewControllerDelegate>)delegate;
-(id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle;
-(void)viewWillAppear:(BOOL)willAppear;
-(void)viewDidAppear:(BOOL)didAppear;
-(void)viewDidDisappear:(BOOL)didDisappear;
-(void)viewDidLoad;
-(void)routingControllerAvailableRoutesDidChange:(MPAVRoutingController *)routingController;
-(void)routingViewController:(MPAVRoutingViewController *)routingViewController didPickRoute:(MPAVRoute *)route;
-(id)_mediaControlsView;
-(void)nowPlayingController:(MPUNowPlayingController *)nowPlayingController playbackStateDidChange:(BOOL)didChange;
-(NSString *)remoteControlInterfaceIdentifier;
-(UIButton *)transportControlsView:(MPUTransportControlsView *)transportControlsView buttonForControlType:(NSInteger)controlType;
-(CGSize)transportControlsView:(MPUTransportControlsView *)transportControlsView defaultTransportButtonSizeWithProposedSize:(CGSize)size;
-(NSArray *)allowedTransportControlTypes;
-(void)_initControlCenterMediaControlsViewController;
-(void)_setRoutingViewControllerVisible:(BOOL)visible animated:(BOOL)animated;
-(void)_pickedRouteHeaderViewTapped:(MPAVRouteHeaderView *)headerView;
-(void)_setupControlCenterPageVisibilityUpdateTimer;
-(void)_reloadRoutingControllerDiscoveryMode;
-(void)_reloadCurrentLayoutStyle;
-(NSUInteger)_currentLayoutStyle;
-(void)mediaControlsView:(MPUMediaRemoteControlsView *)mediaControlsView willTransitionToCompactView:(BOOL)willTransition;
-(void)mediaControlsViewPrimaryActionTriggered:(UIButton *)buttonTriggered;
-(void)controlCenterWillPresent;
-(void)controlCenterDidDismiss;
-(void)controlCenterWillBeginTransition;
-(void)controlCenterDidFinishTransition;
@end
