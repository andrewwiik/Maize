#import "MediaRemote.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import "MZEMediaEffectLabel.h"

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
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *titleLabel;
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *subtitleLabel;
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *sourceLabel;
@property (nonatomic, retain, readwrite) UIView *headerDivider;
@property (nonatomic, retain, readwrite) UIImageView *artworkView;
@property (nonatomic, readwrite) BOOL expanded;
-(id)initWithFrame:(CGRect)arg1;
@end
