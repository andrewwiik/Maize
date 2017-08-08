#import <MaizeUI/MZEMaterialView.h>
#import "MZEConnectivityWiFiNetworksListController.h"
/* 

0.8 is the transform out 

*/

@interface MZEConnectivityWiFiNetworksViewController : UIViewController {
	UIView *_headerView;
	UIView *_footerView;
	MZEConnectivityWiFiNetworksListController *_networksListController;
	MZEMaterialView *_topDividerView;
	MZEMaterialView *_bottomDividerView;
}
@property (nonatomic, retain, readwrite) UIView *headerView;
@property (nonatomic, retain, readwrite) UIView *footerView;
@property (nonatomic, retain, readwrite) MZEConnectivityWiFiNetworksListController *networksListController;
@property (nonatomic, retain, readwrite) MZEMaterialView *topDividerView;
@property (nonatomic, retain, readwrite) MZEMaterialView *bottomDividerView;
@end