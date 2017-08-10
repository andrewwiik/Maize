#import "MZEMediaMetaDataView.h"

@implementation MZEMediaMetaDataView
-(id)initWithFrame:(CGRect)arg1 {
  self = [super initWithFrame:arg1];

  [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(updateMedia)
    name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification
    object:nil];

  self.titleLabel = [[MZEMediaMarqueeLabel alloc] init];
  self.titleLabel.frame = self.bounds;
  self.titleLabel.label.textAlignment = NSTextAlignmentCenter;
  [self addSubview:self.titleLabel];

  self.headerDivider = [[UIView alloc] init];
  self.headerDivider.frame = CGRectMake(0,self.frame.size.height - 0.5, self.frame.size.width, 0.5);
  self.headerDivider.backgroundColor = [UIColor whiteColor];
  self.headerDivider.alpha = 0.080f;
  self.headerDivider.layer.compositingFilter = [NSClassFromString(@"CAFilter") filterWithType:@"plusL"];
  [self addSubview:self.headerDivider];

  self.subtitleLabel = [[MZEMediaMarqueeLabel alloc] init];
  self.subtitleLabel.frame = self.bounds;
  [self addSubview:self.subtitleLabel];

  self.artworkView = [[MZEMediaArtworkView alloc] init];
  self.artworkView.alpha = 0;
  [self addSubview:self.artworkView];

  [self updateMedia];

  return self;
}
-(void)layoutSubviews{

  if(self.titleLabel.label.text == nil){
    self.titleLabel.label.text = @"IPHONE";
    self.subtitleLabel.label.text = @"Music";

    [self.titleLabel.label setEffects:1];
    [self.subtitleLabel.label setEffects:0];

    [self.titleLabel setMarqueeEnabled:FALSE];
    [self.subtitleLabel setMarqueeEnabled:FALSE];
  }

  [self updateFrame];
}
-(void)updateFrame {

  [self.titleLabel.label sizeToFit];
  [self.subtitleLabel.label sizeToFit];

  if(self.expanded){

    float artwork = self.frame.size.height - self.frame.size.width/7;

    self.titleLabel.frame = CGRectMake(artwork + self.frame.size.width/10, self.frame.size.height/4, self.frame.size.width/2, self.frame.size.height/4);
    self.subtitleLabel.frame = CGRectMake(artwork + self.frame.size.width/10, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/4);

    [self.titleLabel contentView].frame = self.titleLabel.label.bounds;
    [self.subtitleLabel contentView].frame = self.subtitleLabel.label.bounds;

    [self.titleLabel setContentSize:CGSizeMake(self.titleLabel.label.frame.size.width, self.titleLabel.label.frame.size.height)];
    [self.titleLabel setBounds:self.titleLabel.bounds];

    [self.subtitleLabel setContentSize:CGSizeMake(self.subtitleLabel.label.frame.size.width, self.subtitleLabel.label.frame.size.height)];
    [self.subtitleLabel setBounds:self.subtitleLabel.bounds];

    self.artworkView.frame = CGRectMake(self.frame.size.width/14, self.frame.size.width/14, artwork, artwork);
    self.headerDivider.frame = CGRectMake(0,self.frame.size.height - 0.5, self.frame.size.width, 0.5);

    self.artworkView.alpha = 1;
    self.headerDivider.alpha = 0.16f;

    if([self.titleLabel.label.text length] > 16){
      [self.titleLabel setMarqueeEnabled:TRUE];
    } else {
      [self.titleLabel setMarqueeEnabled:FALSE];
    }
    self.titleLabel.label.center = CGPointMake(self.titleLabel.label.frame.size.width  / 2, self.titleLabel.frame.size.height / 2);

    if([self.subtitleLabel.label.text length] > 16){
      [self.subtitleLabel setMarqueeEnabled:TRUE];
    } else {
      [self.subtitleLabel setMarqueeEnabled:FALSE];
    }
    self.subtitleLabel.label.center = CGPointMake(self.subtitleLabel.label.frame.size.width/2, self.subtitleLabel.frame.size.height/2);

  } else {


    self.artworkView.alpha = 0;
    self.headerDivider.alpha = 0;

    self.titleLabel.frame = CGRectMake(self.frame.size.width/12, self.frame.size.width/12, self.frame.size.width - self.frame.size.width/6, self.frame.size.height/2 - self.frame.size.width/12);
    self.subtitleLabel.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width, self.frame.size.height/2);

    [self.titleLabel contentView].frame = self.titleLabel.label.bounds;
    [self.subtitleLabel contentView].frame = self.subtitleLabel.label.bounds;

    [self.titleLabel setContentSize:CGSizeMake(self.titleLabel.label.frame.size.width, self.titleLabel.label.frame.size.height)];
    [self.titleLabel setBounds:self.titleLabel.bounds];

    [self.subtitleLabel setContentSize:CGSizeMake(self.subtitleLabel.label.frame.size.width, self.subtitleLabel.label.frame.size.height)];
    [self.subtitleLabel setBounds:self.subtitleLabel.bounds];

    if([self.titleLabel.label.text length] > 16){
      [self.titleLabel setMarqueeEnabled:TRUE];
      self.titleLabel.label.center = CGPointMake(self.titleLabel.label.frame.size.width/2, self.titleLabel.frame.size.height/2);
    } else {
      [self.titleLabel setMarqueeEnabled:FALSE];
      self.titleLabel.label.center = CGPointMake(self.titleLabel.frame.size.width  / 2, self.titleLabel.frame.size.height / 2);
    }

    if([self.subtitleLabel.label.text length] > 16){
      [self.subtitleLabel setMarqueeEnabled:TRUE];
      self.subtitleLabel.label.center = CGPointMake(self.subtitleLabel.label.frame.size.width/2, self.subtitleLabel.frame.size.height/2);
    } else {
      [self.subtitleLabel setMarqueeEnabled:FALSE];
      self.subtitleLabel.label.center = CGPointMake(self.subtitleLabel.frame.size.width  / 2, self.subtitleLabel.frame.size.height / 2);
    }
  }
}
-(void)updateMedia {
  MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
      NSDictionary *dict=(__bridge NSDictionary *)(information);

      if(dict != NULL && [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]!= NULL ){
          if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle] != nil) {
                      NSString *titleText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]];
                      self.titleLabel.label.text = titleText;
          }

          if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist] != nil) {
                      NSString *artistText = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
                      self.subtitleLabel.label.text = artistText;
          }

          if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]!= NULL) {
              UIImage *image = [UIImage imageWithData:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]];
              [self.artworkView setImage:image];
          }

          if(self.titleLabel.label.style == 1 || self.subtitleLabel.label.style == 0){
            [self.titleLabel.label setEffects:0];
            [self.subtitleLabel.label setEffects:2];
          }
      }

      [self updateFrame];
  });
}
@end
