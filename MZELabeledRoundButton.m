#import "MZELabeledRoundButton.h"
#import "MZEFontOptions.h"


@implementation MZELabeledRoundButton
- (id)initWithGlyphPackage:(id)glyphPackage highlightColor:(id)highlightColor {
	self = [self initWithHighlightColor:_highlightColor];

	if (self) {
		_glyphPackage = glyphPackage;
		_buttonView = [[MZERoundButton alloc] initWith]
	}

	return self;
}
- (id)initWithGlyphImage:(id)glyphImage highlightColor:(id)highlightColor {
	self = [self initWithHighlightColor:_highlightColor];
	
	if (self) {

	}

	return self;
}
- (id)initWithHighlightColor:(id)highlightColor {
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
@end