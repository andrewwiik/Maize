#import <UIKit/UIView.h>
#import <MediaPlayerUI/MPUNowPlayingMetadata.h>
#import <MediaPlayerUI/MPUChronologicalProgressView.h>
#import <MediaPlayerUI/MPUTransportControlsView.h>
#import <MediaPlayerUI/MPUMediaControlsVolumeView.h>

@interface MPUMediaRemoteControlsView : UIView {

	BOOL _timeViewVisible;
	UIImage* _artworkImage;
	MPUNowPlayingMetadata* _nowPlayingMetadata;
	NSString* _nowPlayingAppDisplayID;
	MPUChronologicalProgressView* _timeView;
	MPUTransportControlsView* _transportControls;
	MPUMediaControlsVolumeView* _volumeView;

}

@property (nonatomic,retain) UIImage * artworkImage;                                      //@synthesize artworkImage=_artworkImage - In the implementation block
@property (nonatomic,retain) MPUNowPlayingMetadata * nowPlayingMetadata;                  //@synthesize nowPlayingMetadata=_nowPlayingMetadata - In the implementation block
@property (nonatomic,retain) NSString * nowPlayingAppDisplayID;                           //@synthesize nowPlayingAppDisplayID=_nowPlayingAppDisplayID - In the implementation block
@property (assign,nonatomic) BOOL timeViewVisible;                                        //@synthesize timeViewVisible=_timeViewVisible - In the implementation block
@property (nonatomic,readonly) MPUChronologicalProgressView * timeView;                   //@synthesize timeView=_timeView - In the implementation block
@property (nonatomic,readonly) MPUTransportControlsView * transportControls;              //@synthesize transportControls=_transportControls - In the implementation block
@property (nonatomic,readonly) MPUMediaControlsVolumeView * volumeView;                   //@synthesize volumeView=_volumeView - In the implementation block
-(id)initWithFrame:(CGRect)frame;
-(MPUMediaControlsVolumeView *)volumeView;
-(MPUChronologicalProgressView *)timeView;
-(UIImage *)artworkImage;
-(MPUTransportControlsView *)transportControls;
-(void)setNowPlayingMetadata:(MPUNowPlayingMetadata *)metadata;
-(void)setTimeViewVisible:(BOOL)visible;
-(void)setNowPlayingAppDisplayID:(NSString *)displayID;
-(NSString *)nowPlayingAppDisplayID;
-(MPUNowPlayingMetadata *)nowPlayingMetadata;
-(BOOL)timeViewVisible;
-(void)setArtworkImage:(UIImage *)artworkImage;
@end