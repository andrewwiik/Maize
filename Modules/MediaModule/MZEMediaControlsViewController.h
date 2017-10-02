#import "MZETransportControlsView.h"
#import "MZEVolumeView.h"

@interface MZEMediaControlsViewController : UIViewController
@property (nonatomic, assign) bool hasTitles;
@property (nonatomic, assign) bool expanded;
@property (nonatomic, retain, readwrite) MZETransportControlsView *controlsView;
@property (nonatomic, retain, readwrite) MZEVolumeView *volumeView;
-(void)updateMediaForChangeOfMediaControlsStatus;
@end
