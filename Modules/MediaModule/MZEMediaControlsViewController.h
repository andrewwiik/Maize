#import "MZETransportControlsView.h"

@interface MZEMediaControlsViewController : UIViewController
@property (nonatomic, assign) bool hasTitles;
@property (nonatomic, assign) bool expanded;
@property (nonatomic, retain, readwrite) MZETransportControlsView *controlsView;
-(void)updateMediaForChangeOfMediaControlsStatus;
@end
