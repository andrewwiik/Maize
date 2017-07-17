#import "MZEContentModuleBackgroundView.h"
#import "MZEContentModuleContainerView.h"
#import "MZEContentModuleContentContainerView.h"
#import "MZEContentModule-Protocol.h"
#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEContentModuleContentViewController-Protocol.h"

@interface MZEContentModuleContainerViewController : UIViewController <UIGestureRecognizerDelegate, UIPreviewInteractionDelegate>
{
    BOOL _expanded;
    BOOL _contentModuleProvidesOwnPlatter;
    BOOL _didSendContentAppearanceCalls;
    BOOL _didSendContentDisappearanceCalls;
    NSString *_moduleIdentifier;
    __weak id <MZEContentModuleContainerViewControllerDelegate> _delegate;
    id <MZEContentModule> _contentModule;
    UIViewController<MZEContentModuleContentViewController> *_contentViewController;
    UIViewController *_backgroundViewController;
    UIView *_highlightWrapperView;
    MZEContentModuleBackgroundView *_backgroundView;
    MZEContentModuleContentContainerView *_contentContainerView;
    UIView *_contentView;
    UIView *_maskView;
    UITapGestureRecognizer *_tapRecognizer;
    UIPreviewInteraction *_previewInteraction;
    UIViewController *_originalParentViewController;
    UIEdgeInsets _expandedContentEdgeInsets;
    CGFloat _firstX;
    CGFloat _firstY;
    BOOL _canBubble;
}

@property(retain, nonatomic, readwrite) UIViewController *originalParentViewController;
@property(nonatomic, readwrite) BOOL didSendContentDisappearanceCalls; 
@property(nonatomic, readwrite) BOOL didSendContentAppearanceCalls; 
@property(retain, nonatomic, readwrite) UIPreviewInteraction *previewInteraction;
@property(retain, nonatomic, readwrite) UITapGestureRecognizer *tapRecognizer;
@property(retain, nonatomic, readwrite) UIView *maskView;
@property(retain, nonatomic, readwrite) UIView *contentView;
@property(retain, nonatomic, readwrite) MZEContentModuleContentContainerView *contentContainerView;
@property(retain, nonatomic, readwrite) MZEContentModuleBackgroundView *backgroundView;
@property(retain, nonatomic, readwrite) UIView *highlightWrapperView;
@property(nonatomic, readwrite) BOOL contentModuleProvidesOwnPlatter;
@property(retain, nonatomic, readwrite) UIViewController *backgroundViewController;
@property(retain, nonatomic, readwrite) UIViewController<MZEContentModuleContentViewController> *contentViewController;
@property(retain, nonatomic, readwrite) id <MZEContentModule> contentModule;
@property(nonatomic, getter=isExpanded, readwrite) BOOL expanded;
@property(nonatomic) __weak id <MZEContentModuleContainerViewControllerDelegate> delegate;
@property(nonatomic, readwrite) UIEdgeInsets expandedContentEdgeInsets;
@property(copy, nonatomic, readwrite) NSString *moduleIdentifier;
@property(readonly, nonatomic) MZEContentModuleContainerView *moduleContainerView;
- (id)initWithModuleIdentifier:(NSString *)identifier contentModule:(id<MZEContentModule>)contentModule;
- (id)init;
- (id)initWithCoder:(id)arg1;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (void)closeModule;
- (void)willBecomeActive;
- (void)willResignActive;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (void)viewDidAppear:(BOOL)arg1;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)loadView;
- (void)viewWillLayoutSubviews;
- (BOOL)previewInteractionShouldBegin:(UIPreviewInteraction *)previewInteraction;
- (BOOL)_previewInteractionShouldFinishTransitionToPreview:(id)arg1;
- (void)previewInteraction:(UIPreviewInteraction *)previewInteraction didUpdatePreviewTransition:(CGFloat)progress ended:(BOOL)ended;
- (void)previewInteractionDidCancel:(UIPreviewInteraction *)previewInteraction;
- (void)_handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer;
- (CGRect)_contentFrameForRestState;
- (CGRect)_contentFrameForExpandedState;
- (CGRect)_backgroundFrameForRestState;
- (CGRect)_backgroundFrameForExpandedState;
- (CGRect)_contentBoundsForTransitionProgress:(CGFloat)arg1;
- (void)_configureMaskViewIfNecessary;
- (void)_configureForContentModuleGroupRenderingIfNecessary;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end