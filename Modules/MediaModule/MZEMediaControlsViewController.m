#import "MZEMediaControlsViewController.h"

@implementation MZEMediaControlsViewController
-(id)init {
  self = [super init];

  self.controlsView = [[MZETransportControlsView alloc] init];
  [self.view addSubview:self.controlsView];

  self.volumeView = [[MZEVolumeView alloc] init];
  [self.view addSubview:self.volumeView];

  return self;
}
-(void)viewWillLayoutSubviews{
  self.controlsView.expanded = self.expanded;

  if(!self.expanded){
    if(self.hasTitles){
      self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/8, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/2);
    } else {
      self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/4, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/2);
    }
    self.volumeView.hidden = TRUE;
  } else {
    self.controlsView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height/2 - self.view.frame.size.height/12, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/6);

    self.volumeView.frame = CGRectMake(self.view.frame.size.width/16, self.view.frame.size.height - self.view.frame.size.height/6, self.view.frame.size.width - self.view.frame.size.width/8, self.view.frame.size.height/12);

    self.volumeView.hidden = FALSE;
  }
}
-(void)updateMediaForChangeOfMediaControlsStatus {
  [self.controlsView updateMediaForChangeOfMediaControlsStatus];
}
@end
