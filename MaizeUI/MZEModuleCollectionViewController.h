@class MZEModuleContainerViewController;

@interface MZEModuleCollectionViewController : UIViewController <UIPreviewInteractionDelegate> {
	CGFloat _itemSpacingSize;
	CGFloat _edgeInsetSize;
	CGFloat _itemEdgeSize;
	MZEModuleContainerViewController *_expandingModule;
	CGFloat _expandingProgress;
	CGRect _firstFrame;
}
@property (nonatomic, retain) UIViewPropertyAnimator *animator;
@property (nonatomic, retain) NSMutableArray<MZEModuleContainerViewController *> *moduleViewControllers;
@property (nonatomic, assign) CGRect openFrame;
@property (nonatomic, assign) CGRect closedFrame;
- (id)initWithFrame:(CGRect)frame;
@end