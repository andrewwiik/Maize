#import "MZEContentModuleBackgroundView.h"
#import "MZEContentModuleContainerView.h"
#import "MZEContentModuleContentContainerView.h"
#import "MZEContentModule-Protocol.h"
#import "MZEContentModuleContainerViewControllerDelegate-Protocol.h"
#import "MZEContentModuleContentViewController-Protocol.h"

@interface MZEContentModuleContainerViewController : UIViewController <UIGestureRecognizerDelegate, UIPreviewInteractionDelegatePrivate>
{
    BOOL _expanded;
    BOOL _contentModuleProvidesOwnPlatter;
    BOOL _didSendContentAppearanceCalls;
    BOOL _didSendContentDisappearanceCalls;
    NSString *_moduleIdentifier;
    id <MZEContentModuleContainerViewControllerDelegate> _delegate;
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
    struct UIEdgeInsets _expandedContentEdgeInsets;
}

@property(nonatomic) __weak UIViewController *originalParentViewController; // @synthesize originalParentViewController=_originalParentViewController;
@property(nonatomic) BOOL didSendContentDisappearanceCalls; // @synthesize didSendContentDisappearanceCalls=_didSendContentDisappearanceCalls;
@property(nonatomic) BOOL didSendContentAppearanceCalls; // @synthesize didSendContentAppearanceCalls=_didSendContentAppearanceCalls;
@property(retain, nonatomic) UIPreviewInteraction *previewInteraction; // @synthesize previewInteraction=_previewInteraction;
@property(retain, nonatomic) UITapGestureRecognizer *tapRecognizer; // @synthesize tapRecognizer=_tapRecognizer;
@property(retain, nonatomic) UIView *maskView; // @synthesize maskView=_maskView;
@property(retain, nonatomic) UIView *contentView; // @synthesize contentView=_contentView;
@property(retain, nonatomic) MZEContentModuleContentContainerView *contentContainerView; // @synthesize contentContainerView=_contentContainerView;
@property(retain, nonatomic) MZEContentModuleBackgroundView *backgroundView; // @synthesize backgroundView=_backgroundView;
@property(retain, nonatomic) UIView *highlightWrapperView; // @synthesize highlightWrapperView=_highlightWrapperView;
@property(nonatomic) BOOL contentModuleProvidesOwnPlatter; // @synthesize contentModuleProvidesOwnPlatter=_contentModuleProvidesOwnPlatter;
@property(retain, nonatomic) UIViewController *backgroundViewController; // @synthesize backgroundViewController=_backgroundViewController;
@property(retain, nonatomic) UIViewController<MZEContentModuleContentViewController> *contentViewController; // @synthesize contentViewController=_contentViewController;
@property(retain, nonatomic) id <MZEContentModule> contentModule; // @synthesize contentModule=_contentModule;
@property(nonatomic, getter=isExpanded) BOOL expanded; // @synthesize expanded=_expanded;
@property(nonatomic) __weak id <MZEContentModuleContainerViewControllerDelegate> delegate; // @synthesize delegate=_delegate;
@property(nonatomic) struct UIEdgeInsets expandedContentEdgeInsets; // @synthesize expandedContentEdgeInsets=_expandedContentEdgeInsets;
@property(copy, nonatomic) NSString *moduleIdentifier; // @synthesize moduleIdentifier=_moduleIdentifier;
- (void)_configureForContentModuleGroupRenderingIfNecessary;
- (void)_configureMaskViewIfNecessary;
- (struct CGRect)_contentBoundsForTransitionProgress:(double)arg1;
- (struct CGRect)_backgroundFrameForExpandedState;
- (struct CGRect)_backgroundFrameForRestState;
- (struct CGRect)_contentFrameForExpandedState;
- (struct CGRect)_contentFrameForRestState;
- (void)_handleTapGestureRecognizer:(id)arg1;
- (BOOL)_previewInteractionShouldAutomaticallyTransitionToPreviewAfterDelay:(id)arg1;
- (id)_previewInteraction:(id)arg1 viewControllerPresentationForPresentingViewController:(id)arg2;
- (id)_previewInteractionHighlighterForPreviewTransition:(id)arg1;
- (void)previewInteractionDidCancel:(id)arg1;
- (void)previewInteraction:(id)arg1 didUpdatePreviewTransition:(double)arg2 ended:(BOOL)arg3;
- (BOOL)_previewInteractionShouldFinishTransitionToPreview:(id)arg1;
- (BOOL)previewInteractionShouldBegin:(id)arg1;
- (void)viewWillLayoutSubviews;
- (void)loadView;
- (void)viewWillMoveToWindow:(id)arg1;
- (void)viewDidAppear:(BOOL)arg1;
- (BOOL)shouldAutomaticallyForwardAppearanceMethods;
- (void)willResignActive;
- (void)willBecomeActive;
@property(readonly, nonatomic) MZEContentModuleContainerView *moduleContainerView;
- (void)closeModule;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
- (id)initWithCoder:(id)arg1;
- (id)init;
- (id)initWithModuleIdentifier:(id)arg1 contentModule:(id)arg2;

@end