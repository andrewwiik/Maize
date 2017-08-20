#import "MZELabeledRoundButtonViewController.h"

@implementation MZELabeledRoundButtonViewController
@dynamic title;

- (id)initWithGlyphPackage:(CAPackage *)glyphPackage highlightColor:(UIColor *)highlightColor {
	self = [super init];

	if (self) {
		_glyphPackage = glyphPackage;
		self.highlightColor = highlightColor;
	}

	return self;
}
- (id)initWithGlyphImage:(UIImage *)glyphImage highlightColor:(UIColor *)highlightColor {
	self = [super init];

	if (self) {
		_glyphImage = glyphImage;
		self.highlightColor = highlightColor;
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
	if (_toggleStateOnTap) {
		[_button setSelected:[_button isSelected] == NO];
	}
}

- (UIControl *)button {
	[self loadViewIfNeeded];
	return _button;
}

- (void)setLabelsVisible:(BOOL)labelsVisible {
	_labelsVisible = labelsVisible;
	_buttonContainer.labelsVisible = _labelsVisible;
}

- (void)setTitle:(NSString *)title {
	_title = title;
	_buttonContainer.title = title;
}

- (void)setSubtitle:(NSString *)subtitle {
	_subtitle = subtitle;
	_buttonContainer.subtitle = _subtitle;
}

- (void)setInoperative:(BOOL)inoperative {
	_inoperative = inoperative;
	[_button setEnabled:inoperative == NO];
}

- (void)setEnabled:(BOOL)enabled {
	_enabled = enabled;
	[_button setSelected:enabled];
}

- (void)setGlyphState:(NSString *)glyphState {
	_glyphState = glyphState;
	_buttonContainer.glyphState = _glyphState;
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	_glyphImage = glyphImage;
	_buttonContainer.glyphImage = _glyphImage;
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	_glyphPackage = glyphPackage;
	_buttonContainer.glyphPackage = _glyphPackage;
}
@end