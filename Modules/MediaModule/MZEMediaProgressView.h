#import "MZEMediaEffectLabel.h"

@interface MZEMediaProgressView : UIView {
	NSTimer *_updateTimer;
	BOOL _timerStopped;
	NSTimeInterval _duration;
	NSTimeInterval _elapsedTime;
	BOOL _canScrub;

}
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *leftLabel;
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *rightLabel;
@property (nonatomic, retain, readwrite) UISlider *progressView;
@property (nonatomic, assign, readwrite) NSTimeInterval songDuration;
@property (nonatomic, assign, readwrite) BOOL isPlaying;
@property (nonatomic, assign, readwrite) BOOL shouldUpdateTime;
@property (nonatomic, readonly) BOOL hasSong;
@property (nonatomic, assign, readwrite) BOOL canScrub;
// - (void)updateTime;
// - (void)updateTimeAdvanced;
- (void)startTimer;
- (void)stopTimer;
- (void)updateTimeWithElapsedTime:(NSTimeInterval)elapsedTime;

//- (void)setCanScrub:(BOOL)canScrub;
@end
