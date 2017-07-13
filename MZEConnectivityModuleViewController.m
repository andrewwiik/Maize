#import "MZEConnectivityModuleViewController.h"
#import <MPUFoundation/MPULayoutInterpolator.h>


@implementation MZEConnectivityModuleViewController

- (void)loadView {
	[super loadView];

}

- (CGFloat)prefferedContentExpandedWidth {
	return -1;
}
- (CGFloat)prefferedContentExpandedHeight {
	if (!_prefferedContentExpandedHeight) {
		MPULayoutInterpolator *interpolator = [NSClassFromString(@"MPULayoutInterpolator") new];
		[interpolator addValue:403.5 forReferenceMetric:320];
		[interpolator addValue:417.5 forReferenceMetric:375];
		[interpolator addValue:455.5 forReferenceMetric:414];
		_prefferedContentExpandedHeight = [interpolator valueForReferenceMetric:[UIScreen mainScreen].bounds.size.width];
	}

	return _prefferedContentExpandedHeight;
}
- (BOOL)providesOwnPlatter {
	return NO;
}
- (void)previewInteraction:(UIPreviewInteraction *)arg1 didUpdatePreviewTransition:(CGFloat)arg2 ended:(BOOL)arg3 {

}
- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdateCommitTransition:(CGFloat)transitionProgress ended:(BOOL)ended {

}
- (void)previewInteractionDidCancel:(UIPreviewInteraction *)arg1 {

}
@end