#import "MZETransportControlsView.h"
#import "MZEVolumeView.h"
#import "MZEMediaProgressView.h"

@interface MZEMediaControlsViewController : UIViewController
@property (nonatomic, assign) bool hasTitles;
@property (nonatomic, assign) bool expanded;
@property (nonatomic, retain, readwrite) MZETransportControlsView *controlsView;
@property (nonatomic, retain, readwrite) MZEMediaProgressView *progressView;
@property (nonatomic, retain, readwrite) MZEVolumeView *volumeView;
-(void)updateMediaForChangeOfMediaControlsStatus;
@end
