#import <MediaPlayerUI/MPAVRoutingViewController.h>

@interface MPAVRoutingViewController (MZEAirPlayMirroring)
@property (nonatomic, assign) BOOL mze_customDisplay;
@end

@interface MZEAudioRoutingView : UIView
@property (nonatomic, retain, readwrite) MPAVRoutingViewController *routingViewController;
@property (nonatomic, retain, readwrite) UITableView *routingTableView;
@end