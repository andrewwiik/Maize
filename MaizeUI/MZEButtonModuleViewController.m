#import "MZEButtonModuleViewController.h"

@implementation MZEButtonModuleViewController
	@synthesize expanded=_expanded;

- (void)viewDidLoad {
	[super viewDidLoad];
	CGRect frame = CGRectZero;
	if (self.view) {
		frame = self.view.bounds;
	}

	_buttonModuleView = [[MZEButtonModuleView alloc] initWithFrame:frame];
	[_buttonModuleView addTarget:self action:@selector(buttonTapped:forEvent:) forControlEvents:0x40];
	[_buttonModuleView setAutoresizingMask:18];
	[self.view addSubview:_buttonModuleView];
	//[_buttonModuleView addTarget:self action:@selector(buttonTapped:forEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTapped:(UIControl *)button forEvent:(id)event {
	HBLogInfo(@"THE BUTTON WAS TAPPED");
	return;
}

- (UIControl *)buttonView {
	return _buttonModuleView;
}

- (CGFloat)preferredExpandedContentHeight {
	return 0;
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	_expanded = expanded;
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	[self loadViewIfNeeded];
	[_buttonModuleView setGlyphImage:glyphImage];
}

- (UIImage *)glyphImage {
	return [_buttonModuleView glyphImage];
}

- (UIColor *)glyphColor {
	return [_buttonModuleView glyphColor];
}

- (void)setGlyphColor:(UIColor *)glyphColor {
	[self loadViewIfNeeded];
	[_buttonModuleView setGlyphColor:glyphColor];
}

- (void)setSelectedGlyphImage:(UIImage *)selectedGlyphImage {
	[self loadViewIfNeeded];
	[_buttonModuleView setSelectedGlyphImage:selectedGlyphImage];
}

- (UIImage *)selectedGlyphImage {
	return [_buttonModuleView selectedGlyphImage];
}

- (void)setSelectedGlyphColor:(UIColor *)selectedGlyphColor {
	[self loadViewIfNeeded];
	[_buttonModuleView setSelectedGlyphColor:selectedGlyphColor];
}

- (UIColor *)selectedGlyphColor {
	return [_buttonModuleView selectedGlyphColor];
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	[self loadViewIfNeeded];
	[_buttonModuleView setGlyphPackage:glyphPackage];
}

- (CAPackage *)glyphPackage {
	return [_buttonModuleView glyphPackage];
}

- (void)setGlyphState:(NSString *)glyphState {
	[_buttonModuleView setGlyphState:glyphState];
}

- (NSString *)glyphState {
	return [_buttonModuleView glyphState];
}

- (void)setSelected:(BOOL)isSelected {
	[_buttonModuleView setSelected:isSelected];
}

- (BOOL)isSelected {
	return [_buttonModuleView isSelected];
}
@end