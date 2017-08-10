#import "MZEMediaMarqueeLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation MZEMediaMarqueeLabel
-(id)initWithFrame:(CGRect)arg1 {
  self = [super initWithFrame:arg1];

  self.label = [[MZEMediaEffectLabel alloc] initWithFrame:CGRectMake(0, 0, arg1.size.width,   arg1.size.height)];
  [[self contentView] addSubview:self.label];
  [self setViewForContentSize:self.label];
  [self setMarqueeScrollRate:30];
  [self setMarqueeDelay:3];
  [self setContentGap:32];

  return self;
}
-(void)layoutSubviews{
}
@end
