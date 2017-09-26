#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEControlCenterPositionProvider.h"
#import "MZEModuleInstanceManager.h"
#import "MZELayoutStyle.h"
#import "MZEContentModuleContainerViewController.h"
#import "MZEModuleCollectionViewControllerDelegate-Protocol.h"
#import "MZEModuleCollectionView.h"
#import "MZELayoutViewLayoutSource-Protocol.h"


#import <MaizeServices/MZEModuleRepository.h>

@interface MZEModuleCollectionViewController : UIViewController <MZEContentModuleContainerViewControllerDelegate, UIScrollViewDelegate, MZELayoutViewLayoutSource> {
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
    MZEModuleCollectionView *_containerView;
    MZEControlCenterPositionProvider *_currentPositionProvider;
    MZELayoutStyle *_currentLayoutStyle;
}
@property(nonatomic) __weak id <MZEModuleCollectionViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(nonatomic, retain, readwrite) MZEModuleCollectionView *containerView;
@property(nonatomic, retain, readonly) MZEModuleCollectionView *moduleCollectionView;

- (instancetype)initWithModuleInstanceManager:(MZEModuleInstanceManager *)moduleInstanceManager;
- (BOOL)isLandscape;
- (CGSize)layoutSize;
- (CGSize)preferredContentSize;


- (void)willResignActive;
- (void)willBecomeActive;
- (BOOL)handleMenuButtonTap;

- (void)_populateModuleViewControllers;
- (NSArray<MZEModuleInstance *> *)_moduleInstances;
- (void)_removeAndTearDownModuleViewControllerFromHierarchy:(MZEContentModuleContainerViewController *)viewController;
- (void)_setupAndAddModuleViewControllerToHierarchy:(MZEContentModuleContainerViewController *)viewController;

#pragma mark MZELayoutViewLayoutSourceDelegate

- (BOOL)layoutView:(MZELayoutView *)layoutView shouldIgnoreSubview:(UIView *)subview;
- (CGRect)layoutView:(MZELayoutView *)arg1 layoutRectForSubview:(UIView *)subview;
- (CGSize)layoutSizeForLayoutView:(MZELayoutView *)layoutView;

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


#pragma mark Settings Changed
- (void)reloadSettings;
@end