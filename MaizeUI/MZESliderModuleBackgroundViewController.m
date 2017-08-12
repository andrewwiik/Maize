#import "MZESliderModuleBackgroundViewController.h"
#import "MZELayoutOptions.h"
#import "macros.h"

@implementation MZESliderModuleBackgroundViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    _headerImageView = [[UIImageView alloc] init];
    [_headerImageView setContentMode:0x4];
    [_headerImageView sizeToFit];

    _headerImageView.layer.shadowOpacity = 0.2f;
    _headerImageView.layer.shadowOffset = CGSizeZero;
    _headerImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _headerImageView.layer.shadowRadius = 10.0f;

    _packageView = [[MZECAPackageView alloc] init];

    _packageView.layer.shadowOpacity = 0.2f;
    _packageView.layer.shadowOffset = CGSizeZero;
    _packageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _packageView.layer.shadowRadius = 10.0f;

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
	_packageView.frame = CGRectMake(_packageView.frame.origin.x,_packageView.frame.origin.y,_package.rootLayer.bounds.size.width,_package.rootLayer.bounds.size.height);

}

- (void)setGlyphState:(NSString *)glyphState {
	[self loadViewIfNeeded];
	[_packageView setStateName:glyphState];
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	[self loadViewIfNeeded];
	_package = glyphPackage;
	[_packageView setPackage:glyphPackage];
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	[self loadViewIfNeeded];
	[_headerImageView setImage:glyphImage];

}

@end