#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEControlCenterPositionProvider.h"
#import "MZEModuleInstanceManager.h"
#import "MZELayoutStyle.h"

#import <MaizeServices/MZEModuleRepository.h>

@interface MZEModuleCollectionViewController : UIViewController <MZEContentModuleContainerViewControllerDelegate> {
	CGFloat _itemSpacingSize;
	CGFloat _edgeInsetSize;
	CGFloat _itemEdgeSize;
	MZEModuleInstanceManager *_moduleManager;
	MZELayoutStyle *_layoutStyle;
    NSDictionary *_moduleViewControllerByIdentifier;
    MZEControlCenterPositionProvider *_positionProvider;
}

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
- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1;
@end