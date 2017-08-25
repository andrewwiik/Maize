#import "MPAVRoutingViewController.h"
#import "MPAVRoute.h"

@protocol MPAVRoutingViewControllerDelegate
@optional
-(void)routingViewController:(MPAVRoutingViewController *)routingController didPickRoute:(MPAVRoute *)route;
-(void)routingViewControllerDidUpdateContents:(MPAVRoutingViewController *)routingController;
-(void)routingViewControllerDidShowAirPlayDebugScreen:(MPAVRoutingViewController *)routingController;

@end