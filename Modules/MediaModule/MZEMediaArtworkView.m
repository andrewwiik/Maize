#import "MZEMediaArtworkView.h"

@implementation MZEMediaArtworkView
-(id)initWithFrame:(CGRect)arg1 {
  self = [super initWithFrame:arg1];

  self.artworkBackground = [[UIView alloc] init];
  self.artworkBackground.frame = self.bounds;
  self.artworkBackground.backgroundColor = [UIColor whiteColor];
  self.artworkBackground.alpha = 0.16f;
  self.artworkBackground.layer.cornerRadius = 14;
  self.artworkBackground.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
  [self addSubview:self.artworkBackground];

  [self.artworkBackground.layer setShadowColor:[UIColor blackColor].CGColor];
  [self.artworkBackground.layer setShadowOpacity:0.8];
  [self.artworkBackground.layer setShadowRadius:3.0];
  self.artworkBackground.layer.shadowOffset = CGSizeMake(0,0);

  self.imageView = [[UIImageView alloc] init];
  self.imageView.frame = self.bounds;
  self.imageView.layer.cornerRadius = 14;
  self.imageView.clipsToBounds = TRUE;
  self.imageView.opaque = FALSE;
  self.imageView.layer.minificationFilter = kCAFilterTrilinear;
  [self addSubview:self.imageView];

  return self;
}
-(void)layoutSubviews {
  self.artworkBackground.frame = self.bounds;
  self.imageView.frame = self.bounds;
}
-(void)setImage:(UIImage *)arg1 {
  self.imageView.image = arg1;
}
@end
