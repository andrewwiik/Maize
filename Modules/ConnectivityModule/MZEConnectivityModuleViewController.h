#import <MaizeUI/MZEExpandingModuleDelegate-Protocol.h>

@interface MZEConnectivityModuleViewController : UIViewController <MZEExpandingModuleDelegate> {
	CGFloat _prefferedContentExpandedHeight;
}
@property (nonatomic, retain) NSMutableArray *buttonViewControllers;
- (CGFloat)prefferedContentExpandedWidth;
- (CGFloat)prefferedContentExpandedHeight;
- (BOOL)providesOwnPlatter;
- (void)previewInteraction:(UIPreviewInteraction *)arg1 didUpdatePreviewTransition:(CGFloat)arg2 ended:(BOOL)arg3;
- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended;
- (void)previewInteractionDidCancel:(UIPreviewInteraction *)arg1;
@end