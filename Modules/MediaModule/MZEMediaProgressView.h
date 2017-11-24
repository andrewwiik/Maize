#import "MZEMediaEffectLabel.h"

@interface MZEMediaProgressView : UIView {
	NSTimer *_updateTimer;
}
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *leftLabel;
@property (nonatomic, retain, readwrite) MZEMediaEffectLabel *rightLabel;
@property (nonatomic, retain, readwrite) UISlider *progressView;
- (void)updateTime;
- (void)startTimer;
- (void)stopTimer;
@end
