#import "MZELabeledRoundButton.h"
#import "MZEFontOptions.h"


@implementation MZELabeledRoundButton
- (id)initWithGlyphPackage:(CAPackage *)glyphPackage highlightColor:(UIColor *)highlightColor {
	self = [self initWithHighlightColor:_highlightColor];

	if (self) {
		_glyphPackage = glyphPackage;
		_buttonView = [[MZERoundButton alloc] initWithGlyphPackage:glyphPackage highlightColor:highlightColor];
		[_buttonView addTarget:self action:@selector(buttonTapped:) forControlEvents:0x40];
		[self addSubview:_buttonView];
	}

	return self;
}

- (id)initWithGlyphImage:(UIImage *)glyphImage highlightColor:(UIColor *)highlightColor {
	self = [self initWithHighlightColor:_highlightColor];
	
	if (self) {
		_glyphImage = glyphImage;
		_buttonView = [[MZERoundButton alloc] initWithGlyphImage:_glyphImage highlightColor:_highlightColor];
		[_buttonView addTarget:self action:@selector(buttonTapped:) forControlEvents:0x40];
		[self addSubview:_buttonView];
	}

	return self;
}

- (id)initWithHighlightColor:(UIColor *)highlightColor {
	self = [super initWithFrame:CGRectZero];
	if (self) {

		_highlightColor = highlightColor;

		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.clipsToBounds = NO;
		_titleLabel.font = [MZEFontOptions roundButtonTitleFont];
		_titleLabel.text = _title;

		[self addSubview:_titleLabel];

		_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_subtitleLabel.textAlignment = NSTextAlignmentCenter;
		_subtitleLabel.clipsToBounds = NO;
		_subtitleLabel.font = [MZEFontOptions roundButtonSubtitleFont];
		_subtitleLabel.text = _subtitle;

		[self addSubview:_subtitleLabel];

	}

	return self;
}

- (void)_layoutLabels {

}

- (void)buttonTapped:(id)arg1 {

}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(-1,-1);
}
- (CGSize)sizeThatFits:(CGSize)arg1 {
	return CGSizeMake(-1,-1);
}
- (void)layoutSubviews {
	[super layoutSubviews];
}
@end