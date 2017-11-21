#import <MediaPlayerUI/MPAVRoutingViewController.h>
#import "MZEAVRoutingViewController.h"

@interface MPAVRoutingViewController (MZEAirPlayMirroring)
@property (nonatomic, assign) BOOL mze_customDisplay;
@end

@interface MZEAudioRoutingView : UIView
@property (nonatomic, retain, readwrite) MZEAVRoutingViewController *routingViewController;
@property (nonatomic, retain, readwrite) UITableView *routingTableView;
@end