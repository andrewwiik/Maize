#import "MediaRemote.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "MZEMediaEffectLabel.h"
#import "MZEMediaArtworkView.h"
#import "MZEMediaMarqueeLabel.h"
#import "MZEMediaOutputToggleButton.h"

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

@interface MZEMediaMetaDataView : UIView
@property (nonatomic, retain, readwrite) MZEMediaMarqueeLabel *titleLabel;
@property (nonatomic, retain, readwrite) MZEMediaMarqueeLabel *subtitleLabel;
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *sourceLabel;
@property (nonatomic, retain, readwrite) MZEMediaArtworkView *artworkView;
@property (nonatomic, retain, readwrite) MZEMediaOutputToggleButton *outputButton;
@property (nonatomic, retain, readwrite) UIView *headerDivider;
@property (nonatomic, readwrite) BOOL expanded;
-(id)initWithFrame:(CGRect)arg1;
-(void)updateFrame;
-(void)updateMediaForChangeOfMediaControlsStatus;
@end
