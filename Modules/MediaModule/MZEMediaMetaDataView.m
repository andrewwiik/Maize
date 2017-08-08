#import "MZEMediaMetaDataView.h"

@implementation MZEMediaMetaDataView
-(id)initWithFrame:(CGRect)arg1 {
  self = [super initWithFrame:arg1];

  [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(updateMedia)
    name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification
    object:nil];

  self.titleLabel = [[MZEMediaEffectLabel alloc] init];
  self.titleLabel.frame = self.bounds;
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:self.titleLabel];

  self.headerDivider = [[UIView alloc] init];
  self.headerDivider.frame = CGRectMake(0,self.frame.size.height - 0.5, self.frame.size.width, 0.5);
  self.headerDivider.backgroundColor = [UIColor whiteColor];
  self.headerDivider.alpha = 0.080f;
  self.headerDivider.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
  [self addSubview:self.headerDivider];

  self.subtitleLabel = [[MZEMediaEffectLabel alloc] init];
  self.subtitleLabel.frame = self.bounds;
  [self addSubview:self.subtitleLabel];

  self.artworkView = [[MZEMediaArtworkView alloc] init];
  self.artworkView.alpha = 0;
  [self addSubview:self.artworkView];

  return self;
}
-(void)layoutSubviews {
  if(self.expanded){
    self.titleLabel.frame = CGRectMake(self.frame.size.width/4, 0, self.frame.size.width/2, self.frame.size.height/2);
    self.subtitleLabel.frame = CGRectMake(self.frame.size.width/4, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2);
    self.artworkView.frame = CGRectMake(self.frame.size.width/12, self.frame.size.width/12, self.frame.size.width/5, self.frame.size.width/5);

    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.subtitleLabel.textAlignment = NSTextAlignmentLeft;

    self.artworkView.alpha = 1;
    self.headerDivider.alpha = 1;
  } else {
    self.titleLabel.frame = CGRectMake(5,self.frame.size.width/7,self.frame.size.width-10,self.frame.size.width/6);
    self.subtitleLabel.frame = CGRectMake(5,self.frame.size.width/3.5,self.frame.size.width-10,self.frame.size.width/6);

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;

    self.artworkView.alpha = 0;
    self.headerDivider.alpha = 0;
  }

  if(self.titleLabel.text == nil){
    self.titleLabel.text = @"IPHONE";
    self.subtitleLabel.text = @"Music";

    [self.titleLabel setEffects:1];
    [self.subtitleLabel setEffects:0];
  }
}
-(void)updateMedia {
  MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
      NSDictionary *dict=(__bridge NSDictionary *)(information);

      if(dict != NULL && [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]!= NULL ){
          if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] != nil) {
                      NSString *titleText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]];
                      self.titleLabel.text = titleText;
          }

          if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != nil) {
                      NSString *artistText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
                      self.subtitleLabel.text = artistText;
          }

          if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]!= NULL) {
              UIImage *image = [UIImage imageWithData:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]];
              [self.artworkView setImage:image];
          }

          if(self.titleLabel.style == 1 || self.subtitleLabel.style == 0){
            [self.titleLabel setEffects:0];
            [self.subtitleLabel setEffects:2];
          }
      }
  });
}
@end
