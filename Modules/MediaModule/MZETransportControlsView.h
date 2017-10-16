#import "MediaRemote.h"

@interface MZETransportControlsView : UIView
@property (nonatomic, assign) bool expanded;
@property (nonatomic, assign) bool transitioningPlayPause;
@property (nonatomic, retain, readwrite) UIButton *skipButton;
@property (nonatomic, retain, readwrite) UIButton *playButton;
@property (nonatomic, retain, readwrite) UIButton *pauseButton;
@property (nonatomic, retain, readwrite) UIButton *rewindButton;
-(void)updateMediaForChangeOfMediaControlsStatus;
@end
