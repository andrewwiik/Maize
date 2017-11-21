#import "MediaRemote.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "MZEMediaEffectLabel.h"
#import "MZEMediaArtworkView.h"
#import "MZEMediaMarqueeLabel.h"
#import "MZEMediaOutputToggleButton.h"
#import <MediaPlayerUI/MPAVRoutingController.h>

// My SDK and Headers are stuffed so this hack need be done
@interface UIImage (Image)
-(id)_flatImageWithColor:(UIColor *)arg1;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (_Bool)isPlaying;
- (_Bool)pause;
- (_Bool)isPaused;
- (_Bool)isFirstTrack;
- (_Bool)changeTrack:(int)arg1;
- (id)nowPlayingTitle;
+ (_Bool)applicationCanBeConsideredNowPlaying:(id)arg1;
@end

@interface MZEMediaMetaDataView : UIView {
	NSString *_nowPlayingApplicationDisplayName;
	UIImage *_nowPlayingIconImage;
}

@property (nonatomic, retain, readwrite) MZEMediaMarqueeLabel *titleLabel; // Device Connected
@property (nonatomic, retain, readwrite) MZEMediaMarqueeLabel *primaryLabel; // Expanded: Song Name, Compact: Song Name | App Name
@property (nonatomic, retain, readwrite) MZEMediaMarqueeLabel *secondaryLabel; // Expanded: Aritst & Album, Compact: Artist
@property (nonatomic, retain, readwrite) NSString *titleString;
@property (nonatomic, retain, readwrite) NSString *primaryString;
@property (nonatomic, retain, readwrite) NSString *secondaryString;

@property (nonatomic, retain, readwrite) NSString *nowPlayingApplicationID;
@property (nonatomic, retain, readwrite) MZEMediaArtworkView *artworkView;
@property (nonatomic, retain, readwrite) MZEMediaOutputToggleButton *outputButton;
@property (nonatomic, retain, readwrite) UIView *headerDivider;
@property (nonatomic, retain, readwrite) MPAVRoutingController *routingController;
@property (nonatomic, readwrite) BOOL expanded;
- (id)initWithFrame:(CGRect)arg1;
- (void)updateFrame;
- (void)updateMediaForChangeOfMediaControlsStatus;
- (void)updatePickedRoute;
- (void)nowPlayingAppDidChange;
@end
