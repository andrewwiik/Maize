#import "MZEMenuModuleItemView.h"
#import "MZELayoutOptions.h"
#import <QuartzCore/CALayer+Private.h>
#import <QuartzCore/CAFilter+Private.h>
#import <UIKit/UIFontDescriptor+Private.h>
#import "macros.h"

static CGFloat separatorHeight = 0;

@implementation MZEMenuModuleItemView
	@synthesize separatorVisible=_separatorVisible;
	@synthesize handler=_handler;

- (id)initWithTitle:(NSString *)title glyphImage:(UIImage *)glyphImage handler:(MZEMenuItemBlock)handler {
	self = [super initWithFrame:CGRectZero];
	if (self) {

		_separatorVisible = YES;

		if (separatorHeight == 0) {
			separatorHeight = 1.0f/[UIScreen mainScreen].scale;
             //self.layer.delegate = self;
		}

		_glyphImage = glyphImage;

		_highlightedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_highlightedBackgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_highlightedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
		_highlightedBackgroundView.alpha = 0;
		[self addSubview:_highlightedBackgroundView];

		// UIStackView *stackView = [[UIStackView alloc] initWithFrame:self.bounds];
		// [stackView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		// [stackView setAxis:0];
		// [stackView setAlignment:3];
		// [stackView setDistribution:2];
		// [stackView setUserInteractionEnabled:NO];
		if (_glyphImage) {
			_glyphImage = [_glyphImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		}
		_glyphImageView = [[UIImageView alloc] initWithImage:_glyphImage];
		_glyphImageView.contentMode = UIViewContentModeCenter;
		_glyphImageView.tintColor = [UIColor whiteColor];
		[_glyphImageView setUserInteractionEnabled:NO];
		[self addSubview:_glyphImageView];
		_glyphImageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
											UIViewAutoresizingFlexibleBottomMargin |
											UIViewAutoresizingFlexibleTopMargin |
											UIViewAutoresizingFlexibleLeftMargin);

		_titleLabel = [[UILabel alloc] initWithFrame:[self bounds]];
		[_titleLabel setUserInteractionEnabled:NO];

		UIFontDescriptor *labelFontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody addingSymbolicTraits:16384 options:0];
		_titleLabel.font = [UIFont fontWithDescriptor:labelFontDescriptor size:[labelFontDescriptor pointSize]];
		_titleLabel.numberOfLines = 0;
		_titleLabel.text = title;
		_titleLabel.textColor = [UIColor whiteColor];

		[self addSubview:_titleLabel];

		_separatorView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
		_separatorView.frame = CGRectMake(0,CGRectGetHeight(self.bounds) - separatorHeight, CGRectGetWidth(self.bounds) - (glyphImage != nil ? CGRectGetHeight(self.bounds) : 0), separatorHeight);
		//_separatorView.backgroundColor = [UIColor whiteColor];
		// NSMutableArray *sepFilters = [NSMutableArray new];
		// [sepFilters addObject:[NSClassFromString(@"CAFilter") filterWithType:@"vibrantDark"]];
		// _separatorView.layer.filters = [sepFilters copy];
		[self addSubview:_separatorView];

		if (glyphImage) {
			_separatorView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin |
											   UIViewAutoresizingFlexibleRightMargin);
		} else {

			_separatorView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
										   UIViewAutoresizingFlexibleBottomMargin |
										   UIViewAutoresizingFlexibleRightMargin |
										   UIViewAutoresizingFlexibleLeftMargin);
		}

		[self addTarget:self action:@selector(_touchDown:) forControlEvents:UIControlEventTouchDown];
		[self addTarget:self action:@selector(_touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addTarget:self action:@selector(_touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
		[self addTarget:self action:@selector(_dragEnter:) forControlEvents:UIControlEventTouchDragEnter];
		[self addTarget:self action:@selector(_dragExit:) forControlEvents:UIControlEventTouchDragExit];

		_handler = handler;
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];

	_titleLabel.textAlignment = _glyphImage != nil ? NSTextAlignmentNatural : NSTextAlignmentCenter;

	_separatorView.hidden = !_separatorVisible;

	if (_glyphImage) {
		_titleLabel.textAlignment = NSTextAlignmentNatural;
		if (IS_RTL) {
			_glyphImageView.frame = CGRectMake(CGRectGetWidth(self.bounds) - (CGRectGetHeight(self.bounds) + 8),0,(CGRectGetHeight(self.bounds) + 8), CGRectGetHeight(self.bounds));
			_titleLabel.frame = CGRectMake(0,0, CGRectGetWidth(self.bounds) - CGRectGetWidth(_glyphImageView.bounds), CGRectGetHeight(self.bounds));
			
			if (_separatorVisible) {
				_separatorView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - separatorHeight, CGRectGetWidth(self.bounds) - CGRectGetWidth(_glyphImageView.bounds), separatorHeight);
			}
		} else {
			_glyphImageView.frame = CGRectMake(0,0,(CGRectGetHeight(self.bounds) + 8), CGRectGetHeight(self.bounds));
			_titleLabel.frame = CGRectMake(CGRectGetWidth(_glyphImageView.bounds), 0, CGRectGetWidth(self.bounds) - CGRectGetWidth(_glyphImageView.bounds), CGRectGetHeight(self.bounds));
		
			if (_separatorVisible) {
				_separatorView.frame = CGRectMake(CGRectGetWidth(_glyphImageView.bounds), CGRectGetHeight(self.bounds) - separatorHeight, CGRectGetWidth(self.bounds) - CGRectGetWidth(_glyphImageView.bounds), separatorHeight);
			}
		}
	} else {
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.frame = self.bounds;

		if (_separatorVisible) {
			_separatorView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - separatorHeight, CGRectGetWidth(self.bounds), separatorHeight);
		}
	}
}

- (void)_updateForStateChange {


	[UIView animateWithDuration:0.25 animations:^{

		CGFloat alpha = 0.0;
		if (![self isHighlighted]) {
			if ([self isSelected]) {
				alpha = 1.0;
			} else {
				alpha = 0.0;
			}
		} else {
			alpha = 1.0;
		}

		_highlightedBackgroundView.alpha = alpha;
	}];
}

- (void)setEnabled:(BOOL)enabled {
	[super setEnabled:enabled];
	[self _updateForStateChange];
}

- (void)setSelected:(BOOL)selected {
	BOOL updateState = selected != [self isSelected];
	[super setSelected:selected];
	if (updateState)
		[self _updateForStateChange];
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];

	if (!(!highlighted && [self isSelected]))
		[self _updateForStateChange];
}

- (void)_dragExit:(UIControl *)control {
	[self setHighlighted:NO];
}

- (void)_dragEnter:(UIControl *)control {
	[self setHighlighted:YES];
}

- (void)_touchDown:(UIControl *)control {
	[self setHighlighted:YES];
}

- (void)_touchUpOutside:(UIControl *)control {
	[self setHighlighted:NO];
}

- (void)_touchUpInside:(UIControl *)control {
	[self setHighlighted:[self isSelected] ? NO : YES];
}

- (CGSize)sizeThatFits:(CGSize)size {
	return CGSizeMake([MZELayoutOptions defaultExpandedModuleWidth], [MZELayoutOptions defaultMenuItemHeight]);
}

- (CGSize)intrinsicContentSize {
	return [self sizeThatFits:CGSizeZero];
}
@end