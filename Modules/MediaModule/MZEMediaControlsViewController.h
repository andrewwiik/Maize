#import "MZETransportControlsView.h"
#import "MZEVolumeView.h"
#import "MZEMediaProgressView.h"
#import "MZEAudioRoutingView.h"

@interface MZEMediaControlsViewController : UIViewController
@property (nonatomic, assign) bool hasTitles;
@property (nonatomic, assign) bool expanded;
@property (nonatomic, assign) bool showRouting;
@property (nonatomic, retain, readwrite) MZETransportControlsView *controlsView;
@property (nonatomic, retain, readwrite) MZEMediaProgressView *progressView;
@property (nonatomic, retain, readwrite) MZEVolumeView *volumeView;
@property (nonatomic, retain, readwrite) MZEAudioRoutingView *routingView;
@property (nonatomic, retain, readwrite) UIView *controlsContainerView;
-(void)updateMediaForChangeOfMediaControlsStatus;
@end
