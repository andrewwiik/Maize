#import "MZEMediaOutputToggleButton.h"
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>

@implementation MZEMediaOutputToggleButton
-(id)init {
  self = [super init];

  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = [UIColor whiteColor];
  self.backgroundView.alpha = 0.16f;
  self.backgroundView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
  [self addSubview:self.backgroundView];

  self.toggleButton = [[UIButton alloc] init];
  UIImage *btnImage = [[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Library/Application Support/Maize/MediaModule/AirPlay@%@x.png", [NSNumber numberWithFloat:[[UIScreen mainScreen] scale]]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.toggleButton setImage:btnImage forState:UIControlStateNormal];
  self.toggleButton.imageView.layer.minificationFilter = kCAFilterLinear;
  self.toggleButton.tintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
  self.toggleButton.imageEdgeInsets = UIEdgeInsetsMake(5,6,5,6);

  self.toggleButton.contentMode = UIViewContentModeScaleToFill;
  self.toggleButton.imageView.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
  [self addSubview:self.toggleButton];

  self.clipsToBounds = TRUE;
  return self;
}
-(void)layoutSubviews {
  self.backgroundView.frame = self.bounds;
  self.toggleButton.frame = self.bounds;
  self.layer.cornerRadius = self.frame.size.height/2;
}
@end
