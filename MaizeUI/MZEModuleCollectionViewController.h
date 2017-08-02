#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEControlCenterPositionProvider.h"
#import "MZEModuleInstanceManager.h"
#import "MZELayoutStyle.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModuleCollectionViewControllerDelegate-Protocol.h"


#import <MaizeServices/MZEModuleRepository.h>

@interface MZEModuleCollectionViewController : UIViewController <MZEContentModuleContainerViewControllerDelegate> {
	CGFloat _itemSpacingSize;
	CGFloat _edgeInsetSize;
	CGFloat _itemEdgeSize;
	MZEModuleInstanceManager *_moduleInstanceManager;
	MZELayoutStyle *_layoutStyle;
    NSMutableDictionary<NSString *, MZEContentModuleContainerViewController *> *_moduleViewControllerByIdentifier;
    MZEControlCenterPositionProvider *_positionProvider;
    NSMutableArray<MZEContentModuleContainerViewController *> *_currentModules;
    __weak id <MZEModuleCollectionViewControllerDelegate> _delegate;
}
@property(nonatomic) __weak id <MZEModuleCollectionViewControllerDelegate> delegate; // @synthesize delegate=_delegate;

- (instancetype)initWithModuleInstanceManager:(MZEModuleInstanceManager *)moduleInstanceManager;

- (void)willResignActive;
- (void)willBecomeActive;

- (void)_populateModuleViewControllers;
- (NSArray<MZEModuleInstance *> *)_moduleInstances;
- (void)_removeAndTearDownModuleViewControllerFromHierarchy:(MZEContentModuleContainerViewController *)viewController;
- (void)_setupAndAddModuleViewControllerToHierarchy:(MZEContentModuleContainerViewController *)viewController;

#pragma mark MZEContentModuleContainerViewControllerDelegate
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didCloseExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 willCloseExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didOpenExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 willOpenExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didFinishInteractionWithModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didBeginInteractionWithModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController openExpandedModule:(id <MZEContentModule>)expandedModule;
- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1;
@end