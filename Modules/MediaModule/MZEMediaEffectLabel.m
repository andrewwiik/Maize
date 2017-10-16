#import "MZEMediaEffectLabel.h"
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>

@implementation MZEMediaEffectLabel
-(void)setEffects:(int)style {
  // style 2 = transparent color but larger font
  // style 1 = transparent color smaller font
  // style 0 = white transparent

  if(style == 0){
    self.textColor = [UIColor whiteColor];
    self.alpha = 0.8;
    self.layer.compositingFilter = @"plusL";
    self.font = [UIFont boldSystemFontOfSize:17];
    self.style = 0;
  } else if(style == 1){
    self.textColor = [UIColor whiteColor];
    self.alpha = 0.48;
    self.layer.compositingFilter = @"plusL";
    self.font = [UIFont boldSystemFontOfSize:12];
    self.style = 1;
  } else if(style == 2){
    self.textColor = [UIColor whiteColor];
    self.alpha = 0.8;
    self.layer.compositingFilter = @"plusL";
    self.font = [UIFont systemFontOfSize:17];
    self.style = 2;
  } else if(style == 3){
    self.textColor = [UIColor whiteColor];
    self.alpha = 0.8;
    self.layer.compositingFilter = @"plusL";
    self.font = [UIFont boldSystemFontOfSize:12];
    self.style = 1;
  }
}
@end
