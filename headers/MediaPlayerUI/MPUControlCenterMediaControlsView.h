#import <MediaPlayerUI/MPUMediaRemoteControlsView.h>
#import <MediaPlayerUI/MPUControlCenterMediaControlsViewDelegate-Protocol.h>
#import <MediaPlayerUI/MPUControlCenterMediaControlsViewController.h>
#import <MediaPlayerUI/MPUEmptyNowPlayingViewDelegate-Protocol.h>
#import <MPUFoundation/MPULayoutInterpolator.h>
#import <MediaPlayerUI/MPUMediaControlsVolumeView.h>
#import <MediaPlayerUI/MPUTransportControlsView.h>
#import <MediaPlayerUI/MPUControlCenterTimeView.h>
#import <MediaPlayerUI/MPUControlCenterMetadataView.h>
#import <MediaPlayerUI/MPAVRoute.h>
#import <MediaPlayerUI/MPUNowPlayingArtworkView.h>
#import <MediaPlayerUI/MPUAVRouteHeaderView.h>
#import <MediaPlayerUI/MPUEmptyNowPlayingView.h>
#import <MediaPlayerUI/MPUNowPlayingMetadata.h>
#import <SpringBoard/SBApplication.h>

@interface MPUControlCenterMediaControlsView : MPUMediaRemoteControlsView <MPUEmptyNowPlayingViewDelegate> {

	MPULayoutInterpolator* _contentSizeInterpolator;
	MPULayoutInterpolator* _marginLayoutInterpolator;
	MPULayoutInterpolator* _landscapeMarginLayoutInterpolator;
	MPULayoutInterpolator* _artworkNormalContentSizeLayoutInterpolator;
	MPULayoutInterpolator* _artworkLargeContentSizeLayoutInterpolator;
	MPULayoutInterpolator* _artworkLandscapePhoneLayoutInterpolator;
	MPULayoutInterpolator* _labelsLeadingHeightPhoneLayoutInterpolator;
	MPULayoutInterpolator* _transportControlsWidthStandardLayoutInterpolator;
	MPULayoutInterpolator* _transportControlsWidthCompactLayoutInterpolator;
	UIView* _routingContainerView;
	MPUControlCenterMetadataView* _titleLabel;
	MPUControlCenterMetadataView* _artistLabel;
	MPUControlCenterMetadataView* _albumLabel;
	MPUControlCenterMetadataView* _artistAlbumConcatenatedLabel;
	BOOL _unknownApplication;
	BOOL _useCompactStyle;
	BOOL _animating;
	id<MPUControlCenterMediaControlsViewDelegate> _delegate;
	NSUInteger _layoutStyle;
	MPAVRoute* _pickedRoute;
	UIView* _routingView;
	MPUNowPlayingArtworkView* _artworkView;
	MPUAVRouteHeaderView* _pickedRouteHeaderView;
	MPUEmptyNowPlayingView* _emptyNowPlayingView;
	NSUInteger _displayMode;

}

@property (assign,nonatomic) NSUInteger displayMode;
@property (assign,nonatomic) MPUControlCenterMediaControlsViewController *delegate;
@property (assign,nonatomic) NSUInteger layoutStyle;
@property (assign,nonatomic) BOOL useCompactStyle;
@property (nonatomic,retain) MPAVRoute * pickedRoute;
@property (nonatomic,retain) UIView * routingView;
@property (nonatomic,readonly) MPUNowPlayingArtworkView * artworkView;
@property (nonatomic,readonly) MPUAVRouteHeaderView * pickedRouteHeaderView; 
@property (nonatomic,readonly) MPUEmptyNowPlayingView * emptyNowPlayingView;
@property (nonatomic,readonly) BOOL animating;
-(id)initWithFrame:(CGRect)frame;
-(void)layoutSubviews;
-(void)setDelegate:(MPUControlCenterMediaControlsViewController *)delegate;
-(MPUControlCenterMediaControlsViewController *)delegate;
-(void)_init;
-(CGSize)intrinsicContentSize;
-(BOOL)animating;
-(NSUInteger)displayMode;
-(NSUInteger)layoutStyle;
-(void)setLayoutStyle:(NSUInteger)layoutStyle;
-(MPAVRoute *)pickedRoute;
-(MPUMediaControlsVolumeView *)volumeView;
-(MPUControlCenterTimeView *)timeView;
-(MPUNowPlayingArtworkView *)artworkView;
-(void)emptyNowPlayingView:(MPUEmptyNowPlayingView *)emptyNowPlayingView couldNotLoadApplication:(SBApplication *)application;
-(MPUTransportControlsView *)transportControls;
-(void)setNowPlayingMetadata:(MPUNowPlayingMetadata *)nowPlayingMetadata;
-(void)setTimeViewVisible:(BOOL)timeViewVisible;
-(void)setNowPlayingAppDisplayID:(NSString *)displayID;
-(void)setRoutingView:(UIView *)routingView;
-(MPUAVRouteHeaderView *)pickedRouteHeaderView;
-(void)setPickedRoute:(MPAVRoute *)route;
-(BOOL)useCompactStyle;
-(void)setUseCompactStyle:(BOOL)useCompactStyle animated:(BOOL)animated;
-(void)_primaryActionTapped:(UIButton *)primaryActionButton;
-(MPUControlCenterMetadataView *)_createTappableNowPlayingMetadataView;
-(void)_reloadDisplayModeOrCompactStyleVisibility;
-(void)_layoutPhoneCompactStyle;
-(void)_layoutPhoneRegularStyle;
-(BOOL)_nowPlayingMetadataHasDisplayableProperties:(MPUNowPlayingMetadata *)metadata;
-(void)_reloadNowPlayingInfoLabels;
-(void)_layoutPad;
-(void)_layoutPhoneLandscape;
-(void)_layoutPhoneRegularStyleMediaControlsUsingBounds:(CGRect)bounds;
-(CGSize)_artworkViewSize;
-(CGFloat)_standardLabelBoundingBoxPaddingFromMetadataView:(MPUControlCenterMetadataView *)fromMetadataView toMetadataView:(MPUControlCenterMetadataView *)toMetadataView;
-(void)_layoutExpandedRoutingViewUsingBounds:(CGRect)bounds;
-(NSString *)_nowPlayingMetadataTextWithString:(NSString *)string bold:(BOOL)bold centered:(BOOL)centered;
-(BOOL)_routingViewShouldBeVisible;
-(void)setUseCompactStyle:(BOOL)useCompactStyle;
-(UIView *)routingView;
-(MPUEmptyNowPlayingView *)emptyNowPlayingView;
-(void)setDisplayMode:(NSUInteger)displayMode;
-(void)setArtworkImage:(UIImage *)artworkImage;
@end
