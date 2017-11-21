#import <ControlCenterUI/CCUIControlCenterPageContentProviding-Protocol.h>
#import <ControlCenterUI/CCUIControlCenterPageContainerViewController.h>
#import <ControlCenterUI/CCUIControlCenterPagePlatterView.h>
#import "MZEModuleCollectionViewControllerDelegate-Protocol.h"
#import "MZEModularControlCenterViewController.h"
#import "MZEModuleCollectionViewController.h"
#import "MZEContentModule-Protocol.h"


@interface MZEHybridPageViewController : MZEModularControlCenterViewController <CCUIControlCenterPageContentProviding> {
	CCUIControlCenterPageContainerViewController *_delegate;
	_MZEBackdropView *_whiteLayerView;
	UIView *_alternateWhiteLayerView;
	UIView *_snapshotView;
}
@property (nonatomic, retain) CCUIControlCenterPageContainerViewController *delegate;
@property (nonatomic, retain) CCUIControlCenterPagePlatterView *platterView;
@property (nonatomic, retain, readwrite) _MZEBackdropView *whiteLayerView;
- (void)viewDidLoad;
- (void)viewWillLayoutSubviews;
- (UIEdgeInsets)contentInsets;
- (void)controlCenterWillPresent;
- (void)controlCenterDidDismiss;
- (void)controlCenterWillBeginTransition;
- (void)controlCenterDidFinishTransition;
@end