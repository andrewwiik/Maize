#import <MaizeUI/MZEMenuModuleViewController.h>
#import "MPAVRoutingViewController+MZE.h"

@class MZEAirPlayMirroringModule;
@interface MZEAirPlayMirroringModuleViewController : MZEMenuModuleViewController {
	MZEAirPlayMirroringModule *_module;
	MPAVRoutingViewController *_routingViewController;
	UITableView *_routingTableView;
}

@property(nonatomic, retain, readwrite) MZEAirPlayMirroringModule *module;
@property (nonatomic, retain, readwrite) MPAVRoutingViewController *routingViewController;
@property (nonatomic, retain, readwrite) UITableView *routingTableView;
- (id)init;
@end