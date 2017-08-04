#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEControlCenterPositionProvider.h"
#import "MZEModuleInstanceManager.h"
#import "MZELayoutStyle.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModuleCollectionViewControllerDelegate-Protocol.h"
#import "MZEModuleCollectionView.h"


#import <MaizeServices/MZEModuleRepository.h>

@interface MZEModuleCollectionViewController : UIViewController <MZEContentModuleContainerViewControllerDelegate, UIScrollViewDelegate> {
	CGFloat _itemSpacingSize;
	CGFloat _edgeInsetSize;
	CGFloat _itemEdgeSize;
	MZEModuleInstanceManager *_moduleInstanceManager;
	MZELayoutStyle *_portraitLayoutStyle;
	MZELayoutStyle *_landscapeLayoutStyle;
    NSMutableDictionary<NSString *, MZEContentModuleContainerViewController *> *_moduleViewControllerByIdentifier;
    MZEControlCenterPositionProvider *_portraitPositionProvider;
    MZEControlCenterPositionProvider *_landscapePositionProvider;
    NSMutableArray<MZEContentModuleContainerViewController *> *_currentModules;
    __weak id <MZEModuleCollectionViewControllerDelegate> _delegate;
    MZEModuleCollectionView *_scrollView;
}
@property(nonatomic) __weak id <MZEModuleCollectionViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(nonatomic, retain, readwrite) MZEModuleCollectionView *scrollView;

- (instancetype)initWithModuleInstanceManager:(MZEModuleInstanceManager *)moduleInstanceManager;
- (BOOL)isLandscape;
- (CGSize)layoutSize;


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
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)containerViewController closeExpandedModule:(id <MZEContentModule>)expandedModule;
- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1;
@end