#import "MZEVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>

#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIImage+Private.h>

@interface MPVolumeView (Private)
@property (nonatomic, retain, readwrite) UISlider *volumeSlider;
@end

@implementation MZEVolumeView
-(id)init {
  self = [super init];

  self.sliderView = [[MPVolumeView alloc] initWithFrame:CGRectMake(self.bounds.size.height, 0, self.bounds.size.width - self.bounds.size.height*2, self.bounds.size.height)];
  self.sliderView.showsRouteButton = FALSE;
  [self addSubview:self.sliderView];

  // Slider styling
  self.sliderView.volumeSlider.minimumTrackTintColor = [UIColor whiteColor];
  self.sliderView.volumeSlider.maximumTrackTintColor = [UIColor blackColor];

  UIImage *trackImage = [[UIImage imageNamed:@"track" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];
  UIImage *darkTrackImage = [[UIImage imageNamed:@"track" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor blackColor]];

  [self.sliderView.volumeSlider setMinimumTrackImage: trackImage forState: UIControlStateNormal];
  [self.sliderView.volumeSlider setMaximumTrackImage: darkTrackImage forState: UIControlStateNormal];

  UIImage *lowvol = [[UIImage imageNamed:@"lowvol" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];
  UIImage *highvol = [[UIImage imageNamed:@"highvol" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];

  [self.sliderView.volumeSlider setMinimumValueImage:lowvol];
  [self.sliderView.volumeSlider setMaximumValueImage:highvol];

  [self.sliderView.volumeSlider setThumbImage:[UIImage imageNamed:@"thumb" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];

  return self;
}
-(void)layoutSubviews {
  self.sliderView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);


  UIView *_maxTrackClipView = [self.sliderView.volumeSlider valueForKey:@"_maxTrackClipView"];
  _maxTrackClipView.layer.cornerRadius = 2;
  _maxTrackClipView.clipsToBounds = TRUE;

  UIImageView* _minTrackView = [self.sliderView.volumeSlider valueForKey:@"_minTrackView"];
  _minTrackView.layer.cornerRadius = 2;
  _minTrackView.clipsToBounds = TRUE;

}
@end
