#import "MZEMediaArtworkView.h"

@implementation MZEMediaArtworkView
-(id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self) {

    self.layer.cornerRadius = 14.0; // this will need to be changed to continousCornerRadius
    self.clipsToBounds = YES;

    self.artworkBackground = [[UIView alloc] initWithFrame:self.bounds];
    self.artworkBackground.backgroundColor = [UIColor whiteColor];
    self.artworkBackground.alpha = 0.16f;
    self.artworkBackground.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
    [self addSubview:self.artworkBackground];

    [self.artworkBackground.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.artworkBackground.layer setShadowOpacity:0.8];
    [self.artworkBackground.layer setShadowRadius:3.0];
    self.artworkBackground.layer.shadowOffset = CGSizeZero;

    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.bounds;
    self.imageView.opaque = FALSE;
    self.imageView.layer.minificationFilter = kCAFilterTrilinear;
    [self addSubview:self.imageView];
  }

  return self;
}

-(void)layoutSubviews {
  [super layoutSubviews];
  self.artworkBackground.frame = self.bounds;
  self.imageView.frame = self.bounds;
}

-(void)setImage:(UIImage *)image {
  self.imageView.image = image;
}

@end
