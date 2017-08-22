#import "MZEMediaOutputToggleButton.h"
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIImage+Private.h>

@implementation MZEMediaOutputToggleButton
-(id)init {
  self = [super init];

  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = [UIColor whiteColor];
  self.backgroundView.alpha = 0.16f;
  self.backgroundView.layer.compositingFilter = @"plusL";
  [self addSubview:self.backgroundView];

  self.toggleButton = [[UIButton alloc] init];
  UIImage *btnImage = [[UIImage imageNamed:@"AirPlay" inBundle:[NSBundle bundleForClass:[self class]]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  [self.toggleButton setImage:btnImage forState:UIControlStateNormal];
  self.toggleButton.imageView.layer.minificationFilter = kCAFilterLinear;
  self.toggleButton.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
  self.toggleButton.imageEdgeInsets = UIEdgeInsetsMake(5,6,5,6);

  self.toggleButton.contentMode = UIViewContentModeScaleToFill;
  self.toggleButton.imageView.layer.compositingFilter = @"plusL";
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
