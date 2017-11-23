#import "MZEButtonModuleViewController.h"
#import "MZEMenuModuleItemView.h"
#import "MZEMaterialView.h"
#import "_MZEBackdropView.h"
#import "MZEMenuModuleView.h"

@interface MZEMenuModuleViewController : MZEButtonModuleViewController <UIGestureRecognizerDelegate> {
	NSMutableArray<MZEMenuModuleItemView *> *_menuItemsViews;
	UILabel *_titleLabel;
    MZEMaterialView *_headerSeparatorView;
    _MZEBackdropView *_darkBackground;
    MZEMaterialView *_platterBackground;
    UIStackView *_containerView;
    NSString *_title;
    BOOL _shouldProvideOwnPlatter;
    // MZEMenuItemView *_viewToIgnore;
    UILongPressGestureRecognizer *_pressRecognizer;
}

@property (nonatomic, retain, readwrite) NSMutableArray<MZEMenuModuleItemView *> *menuItemsViews;
@property(readonly, nonatomic) CGFloat headerHeight;
@property(copy, nonatomic) NSString *title; 
@property(readonly, nonatomic) CGFloat preferredExpandedContentWidth;
@property(readonly, nonatomic) CGFloat preferredExpandedContentHeight;
@property(readonly, nonatomic) BOOL providesOwnPlatter;
@property (nonatomic, retain, readwrite) _MZEBackdropView *darkBackground;
@property (nonatomic, retain, readwrite) UIStackView *containerView;
@property (nonatomic, retain, readwrite) MZEMaterialView *headerSeparatorView;
@property (nonatomic, assign, readwrite) BOOL shouldProvideOwnPlatter;
@property (nonatomic, retain, readwrite) MZEMenuModuleView *view;
//@property(readonly, nonatomic) _Bool shouldHidePlatterWhenExpanded;

- (void)loadView;
- (void)viewDidLoad;
- (void)viewWillLayoutSubviews;

- (CGFloat)preferredExpandedContentHeight;
- (CGFloat)preferredExpandedContentWidth;

- (void)willTransitionToExpandedContentMode:(BOOL)expanded;
- (void)addActionWithTitle:(NSString *)title glyph:(UIImage *)glyph handler:(MZEMenuItemBlock)handler;

- (CGFloat)headerHeight;
- (CGFloat)_menuItemsHeight;
- (UIFont *)_titleFont;

- (void)_layoutSeparatorForSize:(CGSize)size;
- (void)_layoutMenuItemsForSize:(CGSize)size;
- (void)_layoutTitleLabelForSize:(CGSize)size;
- (void)_layoutGlyphViewForSize:(CGSize)size;

- (void)_fadeViewsForExpandedState:(BOOL)expandedState;
- (void)_handleActionTapped:(MZEMenuModuleItemView *)menuItemView;

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator;

// - (void)touchesBegan:(id)touches withEvent:(id)event;
// - (void)touchesMoved:(id)touches withEvent:(id)event;
// - (void)touchesEnded:(id)touches withEvent:(id)event;
// - (void)touchesCancelled:(id)touches withEvent:(id)event;

- (void)_handlePressGesture:(UILongPressGestureRecognizer *)recognizer;
@end