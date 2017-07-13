#import "MZELabeledRoundButtonViewController.h"

@implementation MZELabeledRoundButtonViewController
- (id)initWithGlyphPackage:(id)glyphPackage highlightColor:(id)highlightColor {
	self = [super init];

	if (self) {
		_glyphPackage = glyphPackage;
		_highlightColor = highlightColor;
	}

	return self;
}
- (id)initWithGlyphImage:(UIImage *)glyphImage highlightColor:(id)highlightColor {
	self = [super init];

	if (self) {
		_glyphImage = glyphImage;
		_highlightColor = highlightColor;
	}

	return self;
}


- (void)loadView {

	if (_glyphPackage) {
		_buttonContainer = [[MZELabeledRoundButton alloc] initWithGlyphPackage:_glyphPackage highlightColor:_highlightColor];
	} else {
		_buttonContainer = [[MZELabeledRoundButton alloc] initWithGlyphImage:_glyphImage highlightColor:_highlightColor];
	}
	
}
@end