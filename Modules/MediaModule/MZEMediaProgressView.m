#import "MZEMediaProgressView.h"
#import "MediaRemote.h"

#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIImage+Private.h>
#import <UIKit/UISlider+Private.h>

@interface SBMediaController : NSObject
+(id)sharedInstance;
-(BOOL)isPlaying;
-(BOOL)beginSeek:(int)arg1;
-(BOOL)endSeek:(int)arg1;
@end

@implementation MZEMediaProgressView
-(id)init {
  self = [super init];

  self.progressView = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2)];
  [self.progressView addTarget:self action:@selector(progressSliderSlidIntoThoseDMs:) forControlEvents:UIControlEventValueChanged];
  
  [self.progressView addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchDown];
  [self.progressView addTarget:self action:@selector(setNewTimeFromSlider:) forControlEvents:UIControlEventTouchUpInside];
  [self.progressView addTarget:self action:@selector(setNewTimeFromSlider:) forControlEvents:UIControlEventTouchUpOutside];
  [self.progressView addTarget:self action:@selector(setNewTimeFromSlider:) forControlEvents:UIControlEventTouchCancel];
  //[self.progressView addTarget:self action:@selector(progressSliderSlidIntoThoseDMs:) forControlEvents:UIControlEventValueChanged];
  [self addSubview:self.progressView];

  // Slider styling
  self.progressView.minimumTrackTintColor = [UIColor whiteColor];
  self.progressView.maximumTrackTintColor = [UIColor colorWithWhite:1 alpha:0.16];

  UIImage *trackImage = [[[UIImage imageNamed:@"track" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor whiteColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];
  UIImage *darkTrackImage = [[[UIImage imageNamed:@"track" inBundle:[NSBundle bundleForClass:[self class]]] _flatImageWithColor:[UIColor colorWithWhite:1 alpha:0.16]] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,0)];

  [self.progressView setMinimumTrackImage: trackImage forState: UIControlStateNormal];
  [self.progressView setMaximumTrackImage: darkTrackImage forState: UIControlStateNormal];

  [self.progressView setThumbImage:[UIImage imageNamed:@"microThumb" inBundle:[NSBundle bundleForClass:[self class]]] forState:UIControlStateNormal];

  self.leftLabel = [[MZEMediaEffectLabel alloc] init];
  [self.leftLabel setEffects:3];
  [self addSubview:self.leftLabel];

  self.rightLabel = [[MZEMediaEffectLabel alloc] init];
  [self.rightLabel setEffects:3];
  self.rightLabel.textAlignment = NSTextAlignmentRight;
  [self addSubview:self.rightLabel];
  _shouldUpdateTime = YES;

 // [self updateTime];

  return self;
}
-(void)layoutSubviews {
  self.progressView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/2);
  self.leftLabel.frame = CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width/4, self.bounds.size.height/2);
  self.rightLabel.frame = CGRectMake(self.bounds.size.width - self.bounds.size.width/4, self.bounds.size.height/2, self.bounds.size.width/4, self.bounds.size.height/2);

  UIView *_maxTrackClipView = [self.progressView valueForKey:@"_maxTrackClipView"];
  _maxTrackClipView.layer.cornerRadius = 1.5;
  _maxTrackClipView.clipsToBounds = TRUE;

  UIImageView* _minTrackView = [self.progressView valueForKey:@"_minTrackView"];
  _minTrackView.layer.cornerRadius = 1.5;
  _minTrackView.clipsToBounds = TRUE;


  if (self.progressView.userInteractionEnabled != _canScrub) {
    [self.progressView _setThumbEnabled:_canScrub];
    [self.progressView setUserInteractionEnabled:_canScrub];

    if (_canScrub) {
      [self.progressView _rebuildControlThumb:YES track:YES];
    }
  }
}



- (void)updateTimeWithElapsedTime:(NSTimeInterval)elapsedTime {

  if (!_shouldUpdateTime || self.progressView.tracking) {
    return;
  }

  if (self.hasSong) {
    NSTimeInterval duration = _songDuration;
    NSTimeInterval realCurrentPlayback = elapsedTime;

    int seconds = (int)realCurrentPlayback % 60;
    int minutes = ((int)realCurrentPlayback / 60) % 60;
    int hours = (int)realCurrentPlayback / 3600;
    if(hours > 0){
      self.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    } else {
      if (minutes < 10) {
        self.leftLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
      } else {
         self.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
      }
     // self.leftLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
    }

    int remainingTime = (duration - realCurrentPlayback);

    int remainingseconds = (int)remainingTime % 60;
    int remainingminutes = ((int)remainingTime / 60) % 60;
    int remaininghours = (int)remainingTime / 3600;

    if(remaininghours > 0){
      self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d",remaininghours, remainingminutes, remainingseconds];
    } else {
      if (remainingminutes < 10) {
        self.rightLabel.text = [NSString stringWithFormat:@"-%01d:%02d", remainingminutes, remainingseconds];
      } else {
        self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d", remainingminutes, remainingseconds];
      }
     // self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d", remainingminutes, remainingseconds];
    }
    [self.progressView setValue:realCurrentPlayback/duration];
    self.canScrub = YES;
  } else {
    [self.progressView setValue:0];
    self.leftLabel.text = @"";
    self.rightLabel.text = @"";
    self.canScrub = NO;
   // [self stopTimer];
  }
}
// -(void)updateTime{

//   if (self.progressView.tracking) {
//     [self stopTimer];
//     return;
//   }

//   SBMediaController *controller = [NSClassFromString(@"SBMediaController") sharedInstance];

//  // if([controller isPlaying]){
//     MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
//       if (result != nil) {
//         //if([controller isPlaying]){
//           CFAbsoluteTime MusicStarted = CFDateGetAbsoluteTime((CFDateRef)[(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTimestamp]);
//           NSTimeInterval timeIntervalifPause = (NSTimeInterval)[[(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] doubleValue];
//           NSTimeInterval duration = (NSTimeInterval)[[(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration] doubleValue];
//           NSTimeInterval nowSec = (CFAbsoluteTimeGetCurrent() - MusicStarted) + (timeIntervalifPause>1?timeIntervalifPause:0);

//           NSTimeInterval currentPlayback = duration?(nowSec/duration):0;
//       		NSTimeInterval realCurrentPlayback = currentPlayback*duration;

//           int seconds = (int)realCurrentPlayback % 60;
//           int minutes = ((int)realCurrentPlayback / 60) % 60;
//           int hours = (int)realCurrentPlayback / 3600;
//           if(hours > 0){
//             self.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
//           } else {
//             if (minutes < 10) {
//               self.leftLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
//             } else {
//                self.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
//             }
//            // self.leftLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
//           }

//           int remainingTime = (duration - realCurrentPlayback);

//           int remainingseconds = (int)remainingTime % 60;
//           int remainingminutes = ((int)remainingTime / 60) % 60;
//           int remaininghours = (int)remainingTime / 3600;

//           if(remaininghours > 0){
//             self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d",remaininghours, remainingminutes, remainingseconds];
//           } else {
//             if (remainingminutes < 10) {
//               self.rightLabel.text = [NSString stringWithFormat:@"-%01d:%02d", remainingminutes, remainingseconds];
//             } else {
//               self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d", remainingminutes, remainingseconds];
//             }
//            // self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d", remainingminutes, remainingseconds];
//           }
//           [self.progressView setValue:realCurrentPlayback/duration];
//           if([controller isPlaying]){
//            [self performSelector:@selector(updateTime) withObject:nil afterDelay:1];
//          } else {
//           [self stopTimer];
//         }
//         //}
//         } else {
//           [self.progressView setValue:0];
//           self.leftLabel.text = @"";
//           self.rightLabel.text = @"";
//           [self stopTimer];
//         }
//     });




 // }

  //[self performSelector:@selector(updateTime) withObject:nil afterDelay:1];
//}

-(void)progressSliderSlidIntoThoseDMs:(UISlider *)slider {
   // MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        NSTimeInterval duration = _songDuration;

        int remainingTime = duration - (duration * slider.value);
        
        int remainingseconds = (int)remainingTime % 60;
        int remainingminutes = ((int)remainingTime / 60) % 60;
        int remaininghours = (int)remainingTime / 3600;
        
        if(remaininghours > 0){
          self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d:%02d",remaininghours, remainingminutes, remainingseconds];
        } else {
          if (remainingminutes < 10) {
            self.rightLabel.text = [NSString stringWithFormat:@"-%01d:%02d", remainingminutes, remainingseconds];
          } else {
            self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d", remainingminutes, remainingseconds];
          }
         // self.rightLabel.text = [NSString stringWithFormat:@"-%02d:%02d", remainingminutes, remainingseconds];
        }
        
        double newDuration = duration - remainingTime;
        int seconds = (int)newDuration % 60;
        int minutes = ((int)newDuration / 60) % 60;
        int hours = (int)newDuration / 3600;
        if(hours > 0){
          self.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        } else {
          if (minutes < 10) {
            self.leftLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
          } else {
             self.leftLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
          }
         // self.leftLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
        }
   // });
}

-(void)setNewTimeFromSlider:(UISlider *)slider {
  _shouldUpdateTime = NO;
   // MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
        NSTimeInterval duration = _songDuration;
        double timeToScrub = duration * (double)slider.value;
        MRMediaRemoteSetElapsedTime(timeToScrub);
        
        [self performSelector:@selector(allowTimeUpdate) withObject:nil afterDelay:0.25];
   // });
}

- (void)allowTimeUpdate {
  _shouldUpdateTime = YES;
}

- (void)startTimer {

  if (_timerStopped) {
    _timerStopped = NO;
   // [self updateTime];
  }


  //[self updateTime];
  // if (_updateTimer) {
  //   [_updateTimer invalidate];
  //   _updateTimer = nil;
  // }
  // //[self updateTime];
  // _updateTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
  // [[NSRunLoop mainRunLoop] addTimer:_updateTimer forMode:NSRunLoopCommonModes];
 //[self updateTime];
}

- (void)stopTimer {
  _timerStopped = YES;
  // if (_updateTimer) {
  //   [_updateTimer invalidate];
  //   _updateTimer = nil;
  // }
  // [self updateTime];
}

- (BOOL)hasSong {
  if (_songDuration > 0) {
    return YES;
  } else return NO;
}

- (void)setCanScrub:(BOOL)canScrub {
  if (canScrub != _canScrub) {
    _canScrub = canScrub;
    [self.progressView _setThumbEnabled:_canScrub];
    [self.progressView setUserInteractionEnabled:_canScrub];

    if (_canScrub) {
      [self.progressView _rebuildControlThumb:YES track:YES];
    }
  }
}
@end
