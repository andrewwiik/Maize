#import "MZEMediaControlsViewController.h"

@implementation MZEMediaControlsViewController
-(id)init {
  self = [super init];

  self.controlsContainerView = [[UIView alloc] init];
  self.controlsContainerView.clipsToBounds = YES;
  [self.view addSubview:self.controlsContainerView];

  self.progressView = [[MZEMediaProgressView alloc] init];
  [self.controlsContainerView addSubview:self.progressView];

  self.controlsView = [[MZETransportControlsView alloc] init];
  [self.controlsContainerView addSubview:self.controlsView];

  self.volumeView = [[MZEVolumeView alloc] init];
  [self.view addSubview:self.volumeView];

  self.routingView = [[MZEAudioRoutingView alloc] init];
  self.routingView.frame = CGRectMake(0,0-self.view.bounds.size.height*0.79,self.view.bounds.size.width,self.view.bounds.size.height*0.79);
  self.routingView.hidden = YES;
  [self.controlsContainerView addSubview:self.routingView];

  return self;
}
-(void)viewWillLayoutSubviews{
  self.controlsView.expanded = self.expanded;
  self.view.clipsToBounds = YES;

  if(!self.expanded){
    self.controlsContainerView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/12, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/6);

    if(self.hasTitles){
      self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/8, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/2);
    } else {
      self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/4, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/2);
    }

    self.volumeView.hidden = TRUE;
    self.progressView.hidden = TRUE;
    self.routingView.hidden = TRUE;
    self.controlsView.alpha = 1;
  } else {

    self.controlsContainerView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height*0.79);
    self.progressView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/12, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/6);

    self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/2 - self.view.frame.size.height/12, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/6);

    self.volumeView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height - self.view.frame.size.height/7, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/12);

    if (self.showRouting) {
      self.routingView.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height*0.79);
      self.routingView.hidden = NO;

      self.progressView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/12 + (self.view.bounds.size.height*0.79), self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/6);

      self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/2 - self.view.frame.size.height/12 + (self.view.bounds.size.height*0.79), self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/6);
      //self.controlsView.alpha = 0;
      //self.progressView.alpha = 0;
     //self.routingView.alpha = 1.0;
    } else {
      self.routingView.frame = CGRectMake(0,0-self.view.bounds.size.height*0.79,self.view.bounds.size.width,self.view.bounds.size.height*0.79);
      //self.controlsView.alpha  = 1;
      //self.progressView.alpha = 1;
      self.volumeView.hidden = FALSE;
      self.progressView.hidden = FALSE;
      //self.routingView.alpha = 0;
    }
  }
}
-(void)updateMediaForChangeOfMediaControlsStatus {
  [self.controlsView updateMediaForChangeOfMediaControlsStatus];
}
@end
