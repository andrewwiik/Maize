#import "MZEMenuModuleViewController.h"
#import "macros.h"
#import <UIKit/UIFont+Private.h>
#import <UIKit/UIFontDescriptor+Private.h>
#import <QuartzCore/CALayer+Private.h>
// #import "MZEMenuModuleItemView.h"

static CGFloat separatorHeight = 0;

@implementation MZEMenuModuleViewController
	@dynamic title;
	@dynamic view;


- (id)init {
	self = [super init];
	if (self) {

		_shouldProvideOwnPlatter = NO;

		if (separatorHeight == 0) {
			separatorHeight = 1.0f/[UIScreen mainScreen].scale;
		}

		_menuItemsViews = [NSMutableArray new];
	}
	return self;
}

- (BOOL)providesOwnPlatter {
	return _shouldProvideOwnPlatter;
}

- (void)loadView {
	MZEMenuModuleView *view =  [MZEMenuModuleView new];
	view.delegateController = self;
    //newView.backgroundColor = [UIColor redColor];

    self.view = view;
}

- (void)viewDidLoad {
	[super viewDidLoad];


	_platterBackground = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleDark];
	_platterBackground.frame = self.view.bounds;
	_platterBackground.hidden = [self providesOwnPlatter] ? NO : YES;
	[self.view addSubview:_platterBackground];
	_platterBackground.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	//_platterBackground.hidden = _shouldProvideOwnPlatter ? NO : YES;


	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_titleLabel.font = [self _titleFont];
	_titleLabel.textAlignment = NSTextAlignmentCenter;
	_titleLabel.text = _title;
	_titleLabel.textColor = [UIColor whiteColor];
	[_titleLabel sizeToFit];
	[self.view addSubview:_titleLabel];
	_titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin |
									UIViewAutoresizingFlexibleLeftMargin);

	_headerSeparatorView = [MZEMaterialView materialViewWithStyle:MZEMaterialStyleNormal];
	_headerSeparatorView.frame = CGRectMake(0,[self headerHeight] - separatorHeight, CGRectGetWidth(self.view.bounds), separatorHeight);
	_headerSeparatorView.hidden = YES;
	[self.view addSubview:_headerSeparatorView];
	_headerSeparatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
											 UIViewAutoresizingFlexibleRightMargin |
											 UIViewAutoresizingFlexibleWidth);


	_darkBackground = [[_MZEBackdropView alloc] init];
	_darkBackground.alpha = 0.05;
	_darkBackground.backgroundColor = [UIColor blackColor];
	//_darkBackground.layer.compositingFilter = @"plusD";
	_darkBackground.frame = CGRectMake(0, [self headerHeight], CGRectGetWidth(self.view.bounds), [self _menuItemsHeight]);
	[self.view addSubview:_darkBackground];

	_containerView = [[UIStackView alloc] initWithFrame:_darkBackground.frame];
	_containerView.alignment = UIStackViewAlignmentLeading;
	_containerView.axis = UILayoutConstraintAxisVertical;
	_containerView.distribution = UIStackViewDistributionFillEqually;
	[self.view addSubview:_containerView];

	MZEMenuModuleItemView *lastItemView;
	for (MZEMenuModuleItemView *menuItemView in _menuItemsViews) {
		[_containerView addArrangedSubview:menuItemView];
		//menuItemView.separatorVisible = YES;
		lastItemView = menuItemView;
	}

	if (lastItemView) {
		lastItemView.separatorVisible = NO;
	}

	[self _fadeViewsForExpandedState:NO];
	[self.view sendSubviewToBack:_platterBackground];

	_pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePressGesture:)];
	_pressRecognizer.minimumPressDuration = 0.0;
	_pressRecognizer.numberOfTouchesRequired = 1;
	[_pressRecognizer setCancelsTouchesInView:NO];
	_pressRecognizer.delaysTouchesEnded = NO;
	_pressRecognizer.delegate = self;
	//_pressRecognizer.allowableMovement = 10.0;
	//_pressRecognizer.delegate = self;
	[self.view addGestureRecognizer:_pressRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)setTitle:(NSString *)title {
	_title = title;
	if (_titleLabel) {
		_titleLabel.text = title;
		[_titleLabel sizeToFit];
		_titleLabel.textColor = [UIColor whiteColor];
		[self.view setNeedsLayout];
		[self.view layoutIfNeeded];
	}
}


- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	CGSize size = self.view.bounds.size;
	_platterBackground.hidden = [self providesOwnPlatter] ? NO : YES;

	[self _layoutSeparatorForSize:size];
	[self _layoutMenuItemsForSize:size];
	[self _layoutTitleLabelForSize:size];
	[self _layoutGlyphViewForSize:size];
}

- (CGFloat)preferredExpandedContentWidth {
	return [MZELayoutOptions defaultExpandedModuleWidth];
}

- (CGFloat)preferredExpandedContentHeight {
	return [self headerHeight] + [self _menuItemsHeight];
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
	[super willTransitionToExpandedContentMode:expanded];
	[self _fadeViewsForExpandedState:expanded];
	[[self buttonView] setHighlighted:NO];
	_headerSeparatorView.hidden = !expanded;
	_containerView.hidden = !expanded;
	_darkBackground.hidden = !expanded;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self _layoutSeparatorForSize:size];
		[self _layoutMenuItemsForSize:size];
		[self _layoutTitleLabelForSize:size];
		[self _layoutGlyphViewForSize:size];
        // do whatever
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

    }];

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)addActionWithTitle:(NSString *)title glyph:(UIImage *)glyph handler:(MZEMenuItemBlock)handler {
	MZEMenuModuleItemView *itemView = [[MZEMenuModuleItemView alloc] initWithTitle:title glyphImage:glyph handler:handler];
	//[itemView addTarget:self action:@selector(_handleActionTapped:) forControlEvents:UIControlEventTouchUpInside];
	[_menuItemsViews addObject:itemView];
	//[_containerView addArrangedSubview:itemView];
}

- (CGFloat)headerHeight {
	return UIRoundToViewScale([[self _titleFont] _scaledValueForValue:15.0] + 58.0 + 24.0, self.view);
}

- (CGFloat)_menuItemsHeight {
	if ([_menuItemsViews count] > 0) {
		return [_menuItemsViews[0] intrinsicContentSize].height * (CGFloat)[_menuItemsViews count];
	} else return 0.0;
}

- (UIFont *)_titleFont {
	UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline addingSymbolicTraits:16386 options:0];
	return [UIFont fontWithDescriptor:fontDescriptor size:[fontDescriptor pointSize]];
}

- (void)_layoutSeparatorForSize:(CGSize)size {
	_headerSeparatorView.frame = CGRectMake(0,[self headerHeight] - separatorHeight, CGRectGetWidth(self.view.bounds), separatorHeight);
}

- (void)_layoutMenuItemsForSize:(CGSize)size {
	if ([self isExpanded]) {
		_containerView.frame = CGRectMake(0, [self headerHeight], CGRectGetWidth(self.view.bounds), [self _menuItemsHeight]);
		_darkBackground.frame = _containerView.frame;
	}
}

- (void)_layoutTitleLabelForSize:(CGSize)size {
	CGRect labelFrame = CGRectZero;
	UIFont *titleFont = [self _titleFont];
	CGSize otherSize = [_titleLabel sizeThatFits:CGSizeMake(size.width, [titleFont lineHeight])];
	labelFrame.origin.x = UIRoundToViewScale((size.width - otherSize.width)*0.5, self.view);
	labelFrame.origin.y = UIRoundToViewScale([titleFont _scaledValueForValue:15.0] + 58.0 - [titleFont ascender],self.view);
	labelFrame.size.width = otherSize.width;
	labelFrame.size.height = otherSize.height;

	_titleLabel.frame = labelFrame;
}

- (void)_layoutGlyphViewForSize:(CGSize)size {
	if ([self isExpanded]) {
		CGRect buttonFrame = CGRectZero;
		buttonFrame.origin.y = 10.0;
		//buttonFrame.x = UIRoundToViewScale((CGRectGetWidth(self.bounds) - [self glyphImage].size.width) * 0.5, self.view);
		buttonFrame.size.width = CGRectGetWidth(self.view.bounds);
		buttonFrame.size.height = 48.0;
		[self buttonView].frame = buttonFrame;
	} else {
		[self buttonView].frame = self.view.bounds;
	}
}

- (void)_fadeViewsForExpandedState:(BOOL)expandedState {
	if (expandedState) {
		_containerView.alpha = 1.0;
		_titleLabel.alpha = 1.0;
		_darkBackground.alpha = 0.05;
	} else {
		_containerView.alpha = 0.0;
		_titleLabel.alpha = 0.0;
		_darkBackground.alpha = 0.0;
	}
}

- (void)_handleActionTapped:(MZEMenuModuleItemView *)menuItemView {
	[self dismissViewControllerAnimated:YES completion:^{
		menuItemView.handler();
	}];

	// if (menuItemView.handler()) {
	// 	[self dismissViewControllerAnimated:YES completion:nil];
	// }
}

- (BOOL)shouldBeginTransitionToExpandedContentModule {
	if ([self _menuItemsHeight] > 0) {
		return YES;
	} else return NO;
}

// - (void)touchesBegan:(id)touches withEvent:(id)event {
// 	for (UIView *menuItemView in _menuItemsViews) {
// 		[menuItemView touchesBegan:touches withEvent:event];
// 	}
// 	self.view.backgroundColor = [UIColor redColor];
// }

// - (void)touchesMoved:(id)touches withEvent:(id)event {
// 	for (UIView *menuItemView in _menuItemsViews) {
// 		[menuItemView touchesMoved:touches withEvent:event];
// 	}
// }

// - (void)touchesEnded:(id)touches withEvent:(id)event {
// 	for (UIView *menuItemView in _menuItemsViews) {
// 		[menuItemView touchesEnded:touches withEvent:event];
// 	}

// 	self.view.backgroundColor = [UIColor blueColor];
// }

// - (void)touchesCancelled:(id)touches withEvent:(id)event {
// 	for (UIView *menuItemView in _menuItemsViews) {
// 		[menuItemView touchesCancelled:touches withEvent:event];
// 	}
// }

- (void)_handlePressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
	if ([self isExpanded]) {

		CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
		// location = [self.view convertPoint:location toView:_containerView];
		if (CGRectContainsPoint(_containerView.frame, location)) {
			location = [self.view convertPoint:location toView:_containerView];
			MZEMenuModuleItemView *touchedItem; 
			for (MZEMenuModuleItemView *menuItemView in _menuItemsViews) {
				if (CGRectContainsPoint(menuItemView.frame, location) && !touchedItem) {
					touchedItem = menuItemView;
				} else {
					if ([menuItemView isHighlighted]) {
						[menuItemView setHighlighted:NO];
					}
				}
			}

			if (touchedItem) {
				if (gestureRecognizer.state == UIGestureRecognizerStateBegan || 
					gestureRecognizer.state == UIGestureRecognizerStateChanged) {

					if (![touchedItem isHighlighted]) {
						[touchedItem setHighlighted:YES];
					}

				} else {
					[touchedItem setHighlighted:NO];
					[self _handleActionTapped:touchedItem];
				}
			}
		} else {
			for (MZEMenuModuleItemView *menuItemView in _menuItemsViews) {
				if ([menuItemView isHighlighted]) {
					[menuItemView setHighlighted:NO];
				}
			}
		}
	}
}
@end