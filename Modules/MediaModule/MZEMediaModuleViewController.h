#import <MaizeUI/MZEExpandingModuleDelegate-Protocol.h>
#import <MaizeUI/MZEContentModuleContentViewController-Protocol.h>

#import <MPUFoundation/MPULayoutInterpolator.h>
#import "MZEMediaLayoutHelper.h"
#import <UIKit/UIScreen+Private.h>
#import "MZEMediaMetaDataView.h"
#import "MZEMediaMetaDataView.h"
#import "MZEMediaControlsViewController.h"
#import <MediaPlayerUI/MPUVolumeHUDController.h>
#import <MediaPlayerUI/MPUNowPlayingController+Private.h>
#import <MediaPlayerUI/MPUNowPlayingDelegate-Protocol.h>

@interface MPUControlCenterMediaControlsViewController : UIViewController
@end

@interface MZEMediaModuleViewController : UIViewController <MZEContentModuleContentViewController, MPUNowPlayingDelegate> {
	CGFloat _prefferedContentExpandedHeight;
	BOOL _isExpanded;
	MPULayoutInterpolator *_interpolator;
	MPUVolumeHUDController *_volumeHUDController;
	MPUNowPlayingController *_nowPlayingController;
	//BOOL _canPlayer;

}
@property (nonatomic, retain, readwrite) MZEMediaMetaDataView *metadataView;
@property (nonatomic, retain, readwrite) MZEMediaControlsViewController *controlsView;
@property (nonatomic, retain, readwrite) MPUVolumeHUDController *volumeHUDController;
@property (nonatomic, retain, readwrite) MPUNowPlayingController *nowPlayingController;
@property (nonatomic, readwrite) BOOL isExpanded;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (CGFloat)preferredExpandedContentWidth;
- (CGFloat)preferredExpandedContentHeight;
- (BOOL)providesOwnPlatter;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (void)willBecomeActive;
- (void)willResignActive;
- (CGRect)rootViewFrame;

#pragma mark MPUNowPlayingDelegate

-(void)nowPlayingController:(MPUNowPlayingController *)controller nowPlayingInfoDidChange:(NSDictionary *)nowPlayingInfo;
-(void)nowPlayingController:(MPUNowPlayingController *)controller playbackStateDidChange:(BOOL)isPlaying;
-(void)nowPlayingController:(MPUNowPlayingController *)controller nowPlayingApplicationDidChange:(id)nowPlayingApplication;
-(void)nowPlayingControllerDidBeginListeningForNotifications:(MPUNowPlayingController *)controller;
-(void)nowPlayingControllerDidStopListeningForNotifications:(MPUNowPlayingController *)controller;
-(void)nowPlayingController:(MPUNowPlayingController *)controller elapsedTimeDidChange:(CGFloat)elapsedTime;

@end
