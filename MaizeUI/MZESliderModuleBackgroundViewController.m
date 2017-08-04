#import "MZESliderModuleBackgroundViewController.h"
#import "MZELayoutOptions.h"
#import "macros.h"

#if __cplusplus
    extern "C" {
#endif
    CGPoint UIPointRoundToViewScale(CGPoint point, UIView *view);
    CGFloat UICeilToViewScale(CGFloat value, UIView *view);
    CGFloat UIRoundToViewScale(CGFloat value, UIView *view);
#if __cplusplus
}
#endif

@implementation MZESliderModuleBackgroundViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    _headerImageView = [[UIImageView alloc] init];
    [_headerImageView setContentMode:0x4];
    [_headerImageView sizeToFit];
    _packageView = [[MZECAPackageView alloc] init];
    [self.view addSubview:_packageView];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	CGRect bounds = CGRectZero;
	CGPoint centerPoint = CGPointMake(0,0);
	if (self.view) {
		bounds = [self.view bounds];
	}

	if (bounds.size.width > bounds.size.height && !(isPad)) {
		CGFloat boundsWidth = CGRectGetHeight(bounds);
		CGFloat expandedWidth = [MZELayoutOptions defaultExpandedSliderWidth];
		CGFloat centerSpaceLeft = (boundsWidth - expandedWidth) * 0.5;
		CGFloat midY = CGRectGetMidY(bounds);
		centerPoint.y = midY;
		centerPoint.x = centerSpaceLeft;
	} else {
		CGFloat boundsHeight = CGRectGetHeight(bounds);
		CGFloat expandedHeight = [MZELayoutOptions defaultExpandedSliderHeight];
		CGFloat centerSpaceLeft = (boundsHeight - expandedHeight) * 0.5;
		CGFloat midX = CGRectGetMidX(bounds);
		centerPoint.y = centerSpaceLeft * 0.5;
		centerPoint.x = midX;
	}

	centerPoint = UIPointRoundToViewScale(centerPoint, _headerImageView);
	_headerImageView.center = centerPoint;
	_packageView.center = centerPoint;

}

- (void)setGlyphState:(NSString *)glyphState {
	[self loadViewIfNeeded];
	[_packageView setStateName:glyphState];
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	[self loadViewIfNeeded];
	[_packageView setPackage:glyphPackage];
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	[self loadViewIfNeeded];
	[_headerImageView setImage:glyphImage];

}

@end