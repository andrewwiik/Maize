#import "MZELabeledRoundButton.h"
#import "MZEFontOptions.h"
#import "MZELayoutOptions.h"
#import <UIKit/UIFont+Private.h>
#import "macros.h"

@implementation MZELabeledRoundButton

// #pragma mark synthesize 

// @synthesize subtitleLabel=_subtitleLabel;
// @synthesize titleLabel=_titleLabel;
// @synthesize highlightColor=_highlightColor;
// @synthesize buttonView=_buttonView;
// @synthesize labelsVisible=_labelsVisible;
// @synthesize glyphState=_glyphState;
// @synthesize glyphPackage=_glyphPackage;
// @synthesize glyphImage=_glyphImage;
// @synthesize subtitle=_subtitle;
// @synthesize title=_title;
// @synthesize buttonSize=_buttonSize;


- (id)initWithGlyphPackage:(CAPackage *)glyphPackage highlightColor:(UIColor *)highlightColor {
	self = [self initWithHighlightColor:highlightColor];

	if (self) {
		_glyphPackage = glyphPackage;
		_highlightColor = highlightColor;

		_buttonView = [[MZERoundButton alloc] initWithGlyphPackage:glyphPackage highlightColor:_highlightColor];
		[_buttonView addTarget:self action:@selector(buttonTapped:) forControlEvents:0x40];
		_buttonView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_buttonView];

		[self addConstraint:Constraint(self.buttonView,NSCCenterX,NSCEqual,self,NSCCenterX,0)];
		[self addConstraint:Constraint(self.buttonView,NSCTop,NSCEqual,self,NSCTop,0)];

		self.buttonWidthConstraint = ConstantConstraint(self.buttonView,NSCWidth,NSCEqual,_buttonSize.width);
		self.buttonHeightConstraint = ConstantConstraint(self.buttonView,NSCHeight,NSCEqual,_buttonSize.height);

		[self addConstraint:self.buttonWidthConstraint];
		[self addConstraint:self.buttonHeightConstraint];

		[self addConstraint:Constraint(self.titleLabel,NSCCenterX,NSCEqual,self,NSCCenterX,0)];
		CGFloat titlePadding = _buttonView.bounds.size.height + ([[MZEFontOptions roundButtonTitleFont] _scaledValueForValue:5] - [MZEFontOptions roundButtonTitleFont].descender);
		[self addConstraint:Constraint(self.titleLabel,NSCTop,NSCEqual,self.buttonView,NSCBottom,titlePadding)];

		[self addConstraint:Constraint(self.subtitleLabel,NSCCenterX,NSCEqual,self,NSCCenterX,0)];
		[self addConstraint:Constraint(self.subtitleLabel,NSCTop,NSCEqual,self.titleLabel,NSCBottom,[MZEFontOptions roundButtonTitleFont].leading)];
		// -2.89
	}

	return self;
}

- (id)initWithGlyphImage:(UIImage *)glyphImage highlightColor:(UIColor *)highlightColor {
	self = [self initWithHighlightColor:highlightColor];
	
	if (self) {
		_glyphImage = glyphImage;
		_buttonView = [[MZERoundButton alloc] initWithGlyphImage:_glyphImage highlightColor:_highlightColor];
		[_buttonView addTarget:self action:@selector(buttonTapped:) forControlEvents:0x40];
		_buttonView.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:_buttonView];

		[self addConstraint:Constraint(self.buttonView,NSCCenterX,NSCEqual,self,NSCCenterX,0)];
		[self addConstraint:Constraint(self.buttonView,NSCTop,NSCEqual,self,NSCTop,0)];

		self.buttonWidthConstraint = ConstantConstraint(self.buttonView,NSCWidth,NSCEqual, _buttonSize.width);
		self.buttonHeightConstraint = ConstantConstraint(self.buttonView,NSCHeight,NSCEqual,_buttonSize.height);

		[self addConstraint:self.buttonWidthConstraint];
		[self addConstraint:self.buttonHeightConstraint];

		[self addConstraint:Constraint(self.titleLabel,NSCCenterX,NSCEqual,self,NSCCenterX,0)];
		CGFloat titlePadding = _buttonView.bounds.size.height + ([[MZEFontOptions roundButtonTitleFont] _scaledValueForValue:5] - [MZEFontOptions roundButtonTitleFont].descender);
		[self addConstraint:Constraint(self.titleLabel,NSCTop,NSCEqual,self.buttonView,NSCBottom,titlePadding)];

		[self addConstraint:Constraint(self.subtitleLabel,NSCCenterX,NSCEqual,self,NSCCenterX,0)];
		[self addConstraint:Constraint(self.subtitleLabel,NSCTop,NSCEqual,self.titleLabel,NSCBottom,[MZEFontOptions roundButtonTitleFont].leading)];



	}

	return self;
}

- (id)initWithHighlightColor:(UIColor *)highlightColor {
	self = [super initWithFrame:CGRectZero];
	if (self) {

		_highlightColor = highlightColor;
		_buttonSize = CGSizeMake([MZELayoutOptions roundButtonSize],[MZELayoutOptions roundButtonSize]);

		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.clipsToBounds = NO;
		_titleLabel.font = [MZEFontOptions roundButtonTitleFont];
		_titleLabel.numberOfLines = 1;
		_titleLabel.text = _title;
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.textColor = [UIColor whiteColor];

		[self addSubview:_titleLabel];
		
		_subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_subtitleLabel.textAlignment = NSTextAlignmentCenter;
		_subtitleLabel.clipsToBounds = NO;
		_subtitleLabel.font = [MZEFontOptions roundButtonSubtitleFont];
		_subtitleLabel.numberOfLines = 1;
		_subtitleLabel.text = _subtitle;
		_subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_subtitleLabel.textColor = [UIColor whiteColor];

		[self addSubview:_subtitleLabel];
	}

	return self;
}

- (void)buttonTapped:(id)arg1 {
	return;
}

- (void)setGlyphImage:(UIImage *)glyphImage {
	_glyphImage = glyphImage;
	[_buttonView setGlyphImage:glyphImage];
}

- (void)setGlyphPackage:(CAPackage *)glyphPackage {
	_glyphPackage = glyphPackage;
	[_buttonView setGlyphPackage:glyphPackage];
}

- (void)setGlyphState:(NSString *)glyphState {
	_glyphState = glyphState;
	[_buttonView setGlyphState:glyphState];
}

- (void)setTitle:(NSString *)title {
	_title = title;
	[_titleLabel setText:title];
	[_titleLabel sizeToFit];
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)setSubtitle:(NSString *)subtitle {
	_subtitle = subtitle;
	[_subtitleLabel setText:_subtitle];
	[_subtitleLabel sizeToFit];
	[self setNeedsLayout];
	[self layoutIfNeeded];
}

- (void)_layoutLabels {

}

- (void)setButtonSize:(CGSize)buttonSize {
	if (buttonSize.width != _buttonSize.width || buttonSize.height != _buttonSize.height) {
		_buttonSize = buttonSize;
		[self setNeedsUpdateConstraints];
	}
}


- (void)updateConstraints {
	self.buttonHeightConstraint.constant = _buttonSize.height;
	self.buttonWidthConstraint.constant = _buttonSize.width;

  	[super updateConstraints];
}

- (CGSize)sizeThatFits:(CGSize)size {
	CGSize buttonSize = [_buttonView sizeThatFits:size];
	if (_labelsVisible) {
		CGFloat titleLineHeight = [MZEFontOptions roundButtonTitleFont].lineHeight + (([[MZEFontOptions roundButtonTitleFont] _scaledValueForValue:5] - [MZEFontOptions roundButtonTitleFont].descender));
		CGFloat titleLeading = [MZEFontOptions roundButtonTitleFont].leading;
		CGFloat subtitleLineHeight = [MZEFontOptions roundButtonSubtitleFont].lineHeight;
		CGFloat subtitleDescender = [MZEFontOptions roundButtonSubtitleFont].descender;
		CGFloat subtitleLeading = [MZEFontOptions roundButtonSubtitleFont].leading;
		CGFloat labelsHeight = UIRoundToViewScale(((subtitleLineHeight + subtitleLeading) + subtitleDescender) + ((titleLeading * 1.0) + titleLineHeight), self);
		buttonSize.height += labelsHeight;
	}

	return CGSizeMake(buttonSize.width, buttonSize.height);
}

- (CGSize)intrinsicContentSize {
	return [self sizeThatFits:CGSizeZero];
}
- (void)layoutSubviews {
	[super layoutSubviews];
	if (_labelsVisible) {
		_titleLabel.alpha = 1.0;
		_subtitleLabel.alpha = 1.0;
	} else {
		_titleLabel.alpha = 0.0;
		_subtitleLabel.alpha = 0.0;
	}
}

- (void)setLabelsVisible:(BOOL)labelsVisible {
	if (_labelsVisible != labelsVisible) {
		_labelsVisible = labelsVisible;
		[self setNeedsLayout];
		[self layoutIfNeeded];
	}
}
@end