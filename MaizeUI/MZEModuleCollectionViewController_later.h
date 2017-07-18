#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"


@interface MZEModuleCollectionViewController : UIViewController <MZEContentModuleContainerViewControllerDelegate> {
	CGFloat _itemSpacingSize;
	CGFloat _edgeInsetSize;
	CGFloat _itemEdgeSize;
}


// MZEContentModuleContainerViewControllerDelegate
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didCloseExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 willCloseExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didOpenExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 willOpenExpandedModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didFinishInteractionWithModule:(id <MZEContentModule>)arg2;
- (void)contentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1 didBeginInteractionWithModule:(id <MZEContentModule>)arg2;
- (CGRect)compactModeFrameForContentModuleContainerViewController:(MZEContentModuleContainerViewController *)arg1;
@end