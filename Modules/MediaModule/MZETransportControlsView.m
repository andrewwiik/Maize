#import "MZETransportControlsView.h"

#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIImage+Private.h>

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (_Bool)isPlaying;
- (_Bool)pause;
- (_Bool)isPaused;
- (_Bool)isFirstTrack;
- (_Bool)changeTrack:(int)arg1;
- (id)nowPlayingTitle;
+ (_Bool)applicationCanBeConsideredNowPlaying:(id)arg1;
-(id)nameOfPickedRoute;
@end

@implementation MZETransportControlsView
-(id)init {
  self = [super init];
  if (self) {
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skipButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    UIImage *skipButtonImage = [[UIImage imageNamed:@"Next" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];
    [self.skipButton setImage:skipButtonImage forState:UIControlStateNormal];
    self.skipButton.alpha = 0.16;
    [self addSubview:self.skipButton];

    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton addTarget:self action:@selector(playPause) forControlEvents:UIControlEventTouchUpInside];
    UIImage *playButtonImage = [[UIImage imageNamed:@"Play" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];
    [self.playButton setImage:playButtonImage forState:UIControlStateNormal];
    self.playButton.alpha = 0.8;
    [self addSubview:self.playButton];

    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseButton addTarget:self action:@selector(playPause) forControlEvents:UIControlEventTouchUpInside];
    UIImage *pauseButtonImage = [[UIImage imageNamed:@"Pause" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];
    [self.pauseButton setImage:pauseButtonImage forState:UIControlStateNormal];
    self.pauseButton.alpha = 0.8;
    [self addSubview:self.pauseButton];

    self.rewindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rewindButton addTarget:self action:@selector(rewind) forControlEvents:UIControlEventTouchUpInside];
    UIImage *rewindButtonImage = [[UIImage imageNamed:@"Previous" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]];
    [self.rewindButton setImage:rewindButtonImage forState:UIControlStateNormal];
    self.rewindButton.alpha = 0.16;
    [self addSubview:self.rewindButton];

    self.rewindButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.skipButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.pauseButton.imageView.contentMode = UIViewContentModeScaleAspectFit;

    self.pauseButton.hidden = TRUE;

    self.skipButton.layer.compositingFilter = @"plusL";

    self.playButton.layer.compositingFilter = @"plusL";

    self.pauseButton.layer.compositingFilter = @"plusL";

    self.rewindButton.layer.compositingFilter = @"plusL";

    self.transitioningPlayPause = FALSE;

    [self updateMediaForChangeOfMediaControlsStatus];
  }

  return self;
}
-(void)layoutSubviews{
  if(self.expanded){
    self.rewindButton.frame = CGRectMake(self.frame.size.width/12, 0, self.frame.size.width/8, self.frame.size.height);
    self.playButton.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/10, 0, self.frame.size.width/5, self.frame.size.height);
    self.pauseButton.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/10, 0, self.frame.size.width/5, self.frame.size.height);
    self.skipButton.frame = CGRectMake(self.frame.size.width - self.frame.size.width/8 - self.frame.size.width/12, 0, self.frame.size.width/8, self.frame.size.height);
  } else {
    self.rewindButton.frame = CGRectMake(self.frame.size.width/16, 0, self.frame.size.width/5, self.frame.size.height);
    self.playButton.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/10, 0, self.frame.size.width/5, self.frame.size.height);
    self.pauseButton.frame = CGRectMake(self.frame.size.width/2 - self.frame.size.width/10, 0, self.frame.size.width/5, self.frame.size.height);
    self.skipButton.frame = CGRectMake(self.frame.size.width - self.frame.size.width/5 - self.frame.size.width/16, 0, self.frame.size.width/5, self.frame.size.height);
  }
}
-(void)skip {
  MRMediaRemoteSendCommand(kMRNextTrack, 0);
}
-(void)playPause {
  if(!self.transitioningPlayPause){
    if([[NSClassFromString(@"SBMediaController") sharedInstance] isPlaying]){
      MRMediaRemoteSendCommand(kMRPause,0);
    } else {
      MRMediaRemoteSendCommand(kMRPlay, 0);
    }

    // Added a delay to prevent all this other rubbish being called a crap ton if someone decides to spam the button.
    self.transitioningPlayPause = TRUE;

    double delayInSeconds = 0.75;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      self.transitioningPlayPause = FALSE;
      [self updateMediaForChangeOfMediaControlsStatus];
    });
  }
}
-(void)rewind {
  MRMediaRemoteSendCommand(kMRPreviousTrack, 0);
}
-(void)updateMediaForChangeOfMediaControlsStatus {
  if([[NSClassFromString(@"SBMediaController") sharedInstance] isPlaying]){
    self.playButton.hidden = TRUE;
    self.pauseButton.hidden = FALSE;
  } else {
    self.playButton.hidden = FALSE;
    self.pauseButton.hidden = TRUE;
  }
}
@end
