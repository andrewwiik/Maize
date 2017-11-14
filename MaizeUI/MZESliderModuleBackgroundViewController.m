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
    _packageView.transform = CGAffineTransformMakeScale(1.5, 1.5);

   // [self.view addSubview:_packageView];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	CGRect bounds = CGRectZero;
	CGPoint centerPoint = CGPointMake(0,0);
	if (self.view) {
		bounds = [self.view bounds];
	}

	if (bounds.size.width > bounds.size.height && !(isPad)) {
		CGFloat boundsWidth = CGRectGetWidth(bounds);
		CGFloat expandedWidth = [MZELayoutOptions defaultExpandedSliderWidth];
		CGFloat centerSpaceLeft = (boundsWidth - expandedWidth) * 0.25;
		CGFloat midY = CGRectGetMidY(bounds);
		centerPoint.y = midY;
		centerPoint.x = centerSpaceLeft;
	} else {
		CGFloat boundsHeight = CGRectGetHeight(bounds);
		CGFloat expandedHeight = [MZELayoutOptions defaultExpandedSliderHeight];
		CGFloat centerSpaceLeft = (boundsHeight - expandedHeight) * 0.25;
		CGFloat midX = CGRectGetMidX(bounds);
		centerPoint.y = centerSpaceLeft;
		centerPoint.x = midX;
	}

	centerPoint = UIPointRoundToViewScale(centerPoint, _headerImageView);
	if (_headerImageView.image) {
		_headerImageView.frame = CGRectMake(_headerImageView.frame.origin.x,_headerImageView.frame.origin.y,_headerImageView.image.size.width,_headerImageView.image.size.height);
	}
	_headerImageView.center = centerPoint;

	if (_package) {
		_packageView.frame = CGRectMake(_packageView.frame.origin.x,_packageView.frame.origin.y,_package.rootLayer.bounds.size.width,_package.rootLayer.bounds.size.height);
	}
	_packageView.center = centerPoint;
}

- (void)setGlyphState:(NSString *)glyphState {
	[self loadViewIfNeeded];
	[_packageView setStateName:glyphState];
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	[self loadViewIfNeeded];
	_package = glyphPackage;
	if (![_packageView superview]) {
		[self.view addSubview:_packageView];
	}
	[_packageView setPackage:glyphPackage];
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	[self loadViewIfNeeded];
	if (![_headerImageView superview]) {
		[self.view addSubview:_headerImageView];
	}
	[_headerImageView setImage:glyphImage];
	[self.view setNeedsLayout];
	[self.view layoutIfNeeded];

}

@end