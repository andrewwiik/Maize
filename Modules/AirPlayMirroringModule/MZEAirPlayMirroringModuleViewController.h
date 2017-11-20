#import <MaizeUI/MZEMenuModuleViewController.h>
#import "MPAVRoutingViewController+MZE.h"
//#import <ControlCenterUI/CCUIAirStuffSectionController.h>

@class MZEAirPlayMirroringModule;
@interface MZEAirPlayMirroringModuleViewController : MZEMenuModuleViewController {
	MZEAirPlayMirroringModule *_module;
	MPAVRoutingViewController *_routingViewController;
	UITableView *_routingTableView;
	//CCUIAirStuffSectionController *_airStuffController;
}

@property(nonatomic, retain, readwrite) MZEAirPlayMirroringModule *module;
@property (nonatomic, retain, readwrite) MPAVRoutingViewController *routingViewController;
@property (nonatomic, retain, readwrite) UITableView *routingTableView;
- (id)init;
@end