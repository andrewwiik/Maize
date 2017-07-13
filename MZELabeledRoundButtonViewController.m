#import "MZELabeledRoundButtonViewController.h"

@implementation MZELabeledRoundButtonViewController
@dynamic title;

- (id)initWithGlyphPackage:(CAPackage *)glyphPackage highlightColor:(UIColor *)highlightColor {
	self = [super init];

	if (self) {
		_glyphPackage = glyphPackage;
		_highlightColor = highlightColor;
	}

	return self;
}
- (id)initWithGlyphImage:(UIImage *)glyphImage highlightColor:(UIColor *)highlightColor {
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

	[_buttonContainer setLabelsVisible:_labelsVisible];
	_buttonContainer.title = self.title;
	_buttonContainer.subtitle = self.title;

	_button = _buttonContainer.buttonView;
	[_button addTarget:self action:@selector(buttonTapped:) forControlEvents:0x40];

	self.view = _buttonContainer;
	
}

- (void)buttonTapped:(id)arg1 {

}
@end